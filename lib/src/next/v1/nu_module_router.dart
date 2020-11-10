import 'package:flutter/widgets.dart';

import '../../nurouter.dart';
import '../../nuvigator.dart';
import '../../screen_route.dart';
import '../nu_route_module.dart';

abstract class NuModuleRouter extends NuRouter {
  List<NuRouteModule> get modules;
  Widget loadingWidget(BuildContext _) => Container();
  List<NuRouteModule> _modules;
  String get initialRoute;

  Future<void> init(BuildContext context) async {
    final modulesToRegister = <NuRouteModule>[];
    for (final module in modules) {
      final shouldRegister = await module.init(context);
      if (shouldRegister) {
        modulesToRegister.add(module);
      }
    }
    _modules = modulesToRegister;
  }

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _modules.fold(
        {},
        (acc, module) {
          return {
            ...acc,
            RouteDef(module.path, deepLink: module.path): (settings) =>
                module.getRoute(
                  module.getRouteMatchForDeepLink(settings.name),
                ),
          };
        },
      );
}

class Nuvigator2 extends StatelessWidget {
  const Nuvigator2({Key key, this.moduleRouter}) : super(key: key);

  final NuModuleRouter moduleRouter;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: moduleRouter.init(context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
          snapshot.hasData
              ? Nuvigator(
                  router: moduleRouter,
                  initialDeepLink: Uri.parse(moduleRouter.initialRoute),
                )
              : moduleRouter.loadingWidget(context),
    );
  }
}
