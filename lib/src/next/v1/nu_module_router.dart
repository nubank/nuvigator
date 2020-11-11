import 'package:flutter/widgets.dart';

import '../../nurouter.dart';
import '../../screen_route.dart';
import '../nu_route_module.dart';

abstract class NuModuleRouter extends NuRouter {
  List<NuRouteModule> get modules;

  Widget loadingWidget(BuildContext _) => Container();
  List<NuRouteModule> _modules;

  String get initialRoute;

  /// Do not override, this will call a custom [NuModuleRouter.init]
  Future<void> initRouter(BuildContext context) async {
    final modulesToRegister = <NuRouteModule>[];
    final futures = modules.map((module) async {
      final shouldRegister = await module.init(context);
      if (shouldRegister) {
        modulesToRegister.add(module);
      }
    });
    await Future.wait(futures);
    _modules = modulesToRegister;
    print(_modules);
    await init(context);
  }

  Future<void> init(BuildContext context) async {}

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _modules.fold(
        {},
        (acc, module) {
          return {
            ...acc,
            RouteDef(module.path, deepLink: module.path): (settings) {
              final Map<String, dynamic> params =
                  (settings.arguments is Map<String, dynamic>)
                      ? settings.arguments
                      : null;
              final match =
                  module.getRouteMatch(settings.name, extraParameters: params);
              return module.getRoute(match);
            },
          };
        },
      );
}
