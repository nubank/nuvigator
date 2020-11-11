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
            RouteDef(module.path, deepLink: module.path): (settings) {
              final Map<String, dynamic> params =
                  (settings.arguments is Map<String, dynamic>)
                      ? settings.arguments
                      : null;
              final match = module.getRouteMatchForDeepLink(settings.name,
                  extraParameters: params);
              return module.getRoute(match);
            },
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
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ? Nuvigator(
                  router: moduleRouter,
                  initialDeepLink: Uri.parse(moduleRouter.initialRoute),
                )
              : moduleRouter.loadingWidget(context),
    );
  }
}
