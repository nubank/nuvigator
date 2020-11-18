import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';

import '../../nurouter.dart';
import '../../screen_route.dart';
import '../nu_route.dart';

abstract class NuModule {
  NuModule() {
    _subModules = createModules;
    _routes = createRoutes;
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
    for (final route in _routes) {
      route.install(this);
    }
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

  ScreenRoute _getScreenRoute(String deepLink,
      {Map<String, dynamic> parameters}) {
    for (final route in routes) {
      final match = route.getRouteMatch(deepLink, extraParameters: parameters);
      if (match != null) {
        return route.getScreenRoute(match)?.wrapWith(routeWrapper);
      }
    }
    for (final subModule in subModules) {
      return subModule
          ._getScreenRoute(deepLink, parameters: parameters)
          ?.wrapWith(routeWrapper);
    }
    return null;
  }
}

class NuModuleRouter<T extends NuModule> extends NuRouter {
  NuModuleRouter(this.module) {
    module._syncInit(this);
  }

  final T module;

  Future<NuModuleRouter> initModule(BuildContext context) async {
    await module._initModule(context, this);
    return this;
  }

  @override
  Route<R> getRoute<R>(String deepLink, {Map<String, dynamic> parameters}) {
    return module
        ._getScreenRoute(deepLink,
            parameters: parameters ?? <String, dynamic>{})
        ?.toRouteUsingMatch();
  }
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
