import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';

class InitTestNextRouter extends NuRouter {
  InitTestNextRouter({
    @required this.routerInitFuture,
    @required this.routeInitFuture,
  })  : assert(routerInitFuture != null),
        assert(routeInitFuture != null);

  static const initRoute = 'foo', successText = 'Success';

  final Future<void> Function() routerInitFuture;
  final Future<bool> Function() routeInitFuture;

  @override
  String get initialRoute => initRoute;

  @override
  bool get awaitForInit => true;

  @override
  ScreenType get screenType => const MaterialScreenType();

  @override
  Future<void> init(BuildContext context) => routerInitFuture();

  @override
  Widget onError(Object error, NuRouterController controller) {
    return Text(error.runtimeType.toString());
  }

  @override
  List<NuRoute<NuRouter, Object, Object>> get registerRoutes => [
        NuRouteBuilder(
          builder: (context, route, settings) => const Text(successText),
          path: initialRoute,
          initializer: (context) => routeInitFuture(),
        ),
      ];
}
