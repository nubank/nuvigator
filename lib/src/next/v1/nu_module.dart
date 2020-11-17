import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';

import '../../nurouter.dart';
import '../../screen_route.dart';
import '../nu_route.dart';

abstract class NuModule {
  NuModule() {
    _subModules = createModules;
    _routes = createRoutes;
    for (final route in _routes) {
      route.install(this);
    }
    _subModules = createModules;
  }

  List<NuRoute> _routes;
  List<NuModule> _subModules;
  NuModuleRouter _router;

  Widget loadingWidget(BuildContext _) => Container();

  String get initialRoute => null;

  List<NuRoute> get createRoutes;

  List<NuModule> get createModules => [];

  List<NuRoute> get routes => _routes;

  List<NuModule> get subModules => _subModules;

  NuvigatorState get nuvigator => _router.nuvigator;

  void _syncInit(NuModuleRouter router) {
    _router = router;
    _subModules.map((module) => module._syncInit(router));
  }

  Future<void> _initModule(BuildContext context, NuModuleRouter router) async {
    await init(context);
    await Future.wait(_routes.map((route) async {
      await route.init(context);
    }));
    await Future.wait(_subModules.map((module) async {
      return module._initModule(context, router);
    }));
  }

  Future<void> init(BuildContext context) async {}

  Widget routeWrapper(BuildContext context, Widget child) {
    return child;
  }
}

class NuModuleRouter<T extends NuModule> extends NuRouter {
  NuModuleRouter(this.module) {
    module._syncInit(this);
    _subRouters = module.subModules.map((e) => NuModuleRouter(e)).toList();
  }

  final T module;
  List<NuModuleRouter> _subRouters;

  Future<NuModuleRouter> initModule(BuildContext context) async {
    await module._initModule(context, this);
    return this;
  }

  @override
  WrapperFn get screensWrapper => module.routeWrapper;

  @override
  List<NuRouter> get routers => _subRouters ?? [];

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => module.routes.fold(
        {},
        (acc, route) => {
          ...acc,
          RouteDef(route.path, deepLink: route.path): (settings) {
            final Map<String, dynamic> params =
                (settings.arguments is Map<String, dynamic>)
                    ? settings.arguments
                    : null;
            final match =
                route.getRouteMatch(settings.name, extraParameters: params);
            return route.getRoute(match);
          },
        },
      );
}

class NuModuleLoader extends StatefulWidget {
  const NuModuleLoader({Key key, this.module, this.builder}) : super(key: key);

  final NuModule module;
  final Widget Function(NuModuleRouter router) builder;

  @override
  _NuModuleLoaderState createState() => _NuModuleLoaderState();
}

class _NuModuleLoaderState extends State<NuModuleLoader> {
  bool loading = true;
  NuModuleRouter router;

  @override
  void initState() {
    router = NuModuleRouter(widget.module);
    router.initModule(context).then((value) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return widget.module.loadingWidget(context);
    }
    return widget.builder(router);
  }
}
