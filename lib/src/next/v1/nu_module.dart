import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';

import '../../nurouter.dart';
import '../../screen_route.dart';
import '../nu_route.dart';

abstract class NuModule {
  NuModule() {
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

  /// Do not override, this will call a custom [NuModuleRouter.init]
  Future<void> _initModule(BuildContext context, NuModuleRouter router) async {
    await init(context);
    _router = router;
    final routesToRegister = <NuRoute>[];
    final futures = createRoutes.map((route) async {
      final shouldRegister = await route.init(context);
      if (shouldRegister) {
        routesToRegister.add(route);
      }
    });
    await Future.wait(futures);
    _routes = routesToRegister;
    _subModules = createModules;
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
  NuModuleRouter(this.module);

  final T module;
  List<NuModuleRouter> _subRouters;

  Future<NuModuleRouter> initModule(BuildContext context) async {
    await module._initModule(context, this);
    _subRouters = module.subModules.map((e) => NuModuleRouter(e)).toList();
    print(module.subModules);
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
