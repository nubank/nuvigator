import 'package:flutter/widgets.dart';

import 'nurouter.dart';
import 'route_path.dart';
import 'screen_route.dart';

class GenericRouter extends NuRouter {
  GenericRouter(
      {List<NuRouter> routers = const [],
      Map<RoutePath, ScreenRouteBuilder> screensMap = const {}})
      : _routers = routers,
        _screensMap = screensMap;

  final List<NuRouter> _routers;
  final Map<RoutePath, ScreenRouteBuilder> _screensMap;

  void route(RoutePath path, ScreenRoute screenRoute) {
    screensMap[path] = (settings) {
      return screenRoute;
    };
  }

  @override
  Map<RoutePath, ScreenRouteBuilder> get screensMap => _screensMap;

  @override
  List<NuRouter> get routers => _routers;
}

NuRouter mergeRouters(List<NuRouter> routers) {
  return GenericRouter(routers: routers);
}

class SingleRouteHandler extends GenericRouter {
  SingleRouteHandler(this.routePath, this.screenRoute)
      : super(screensMap: {routePath: (settings) => screenRoute});

  final RoutePath routePath;
  final ScreenRoute screenRoute;

  static Map<String, Object> args(BuildContext context) {
    return ModalRoute.of(context).settings.arguments;
  }
}
