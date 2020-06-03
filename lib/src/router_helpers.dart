import 'package:flutter/widgets.dart';

import 'route_path.dart';
import 'router.dart';
import 'screen_route.dart';

class GenericRouter extends Router {
  GenericRouter(
      {List<Router> routers = const [],
      Map<RoutePath, ScreenRouteBuilder> screensMap = const {}})
      : _routers = routers,
        _screensMap = screensMap;

  final List<Router> _routers;
  final Map<RoutePath, ScreenRouteBuilder> _screensMap;

  void route(RoutePath path, ScreenRoute screenRoute) {
    screensMap[path] = (settings) {
      return screenRoute;
    };
  }

  @override
  Map<RoutePath, ScreenRouteBuilder> get screensMap => _screensMap;

  @override
  List<Router> get routers => _routers;
}

Router mergeRouters(List<Router> routers) {
  return GenericRouter(routers: routers);
}

Router singleRoute(RoutePath routePath, ScreenRoute screenRoute) {
  return GenericRouter(screensMap: {
    routePath: (settings) => screenRoute,
  });
}

class RouteHandler extends GenericRouter {
  RouteHandler(this.routePath, this.screenRoute)
      : super(screensMap: {routePath: (settings) => screenRoute});

  final RoutePath routePath;
  final ScreenRoute screenRoute;

  static Map<String, Object> args(BuildContext context) {
    return ModalRoute.of(context).settings.arguments;
  }
}
