import 'package:flutter/widgets.dart';

import 'router.dart';
import 'screen_route.dart';

class GenericRouter extends Router {
  GenericRouter(
      {List<Router> routers = const [],
      Map<String, ScreenRouteBuilder> screensMap = const {}})
      : _routers = routers,
        _screensMap = screensMap;

  final List<Router> _routers;
  final Map<String, ScreenRouteBuilder> _screensMap;

  void route(String path, ScreenRoute screenRoute) {
    screensMap[path] = (settings) {
      return screenRoute;
    };
  }

  @override
  Map<String, ScreenRouteBuilder> get screensMap => _screensMap;

  @override
  List<Router> get routers => _routers;
}

Router mergeRouters(List<Router> routers) {
  return GenericRouter(routers: routers);
}

Router singleRoute(String routePath, ScreenRoute screenRoute) {
  return GenericRouter(screensMap: {
    routePath: (settings) => screenRoute,
  });
}

class RouteHandler extends GenericRouter {
  RouteHandler(this.routePath, this.screenRoute)
      : super(screensMap: {routePath: (settings) => screenRoute});

  final String routePath;
  final ScreenRoute screenRoute;

  static Map<String, Object> args(BuildContext context) {
    return ModalRoute.of(context).settings.arguments;
  }
}

void aa() {
  final lendingRoutes = mergeRouters([
    RouteHandler('nuapp://onboarding/:id', ScreenRoute(builder: (context) {
      return null;
    })),
  ]);
}
