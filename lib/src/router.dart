import 'package:flutter/material.dart';

import '../nuvigator.dart';
import 'helpers.dart';
import 'screen_route.dart';

typedef ScreenRouteBuilder = ScreenRoute Function(RouteSettings settings);
typedef HandleDeepLinkFn = Future<dynamic>
    Function(Router router, String deepLink, [dynamic args, bool isFromNative]);

class RouteEntry {
  RouteEntry(this.routeName, this.screenBuilder);

  final String routeName;
  final ScreenRouteBuilder screenBuilder;

  @override
  int get hashCode => routeName.hashCode;

  @override
  bool operator ==(Object other) =>
      other is RouteEntry && other.routeName == routeName;
}

abstract class Router {
  static T of<T extends Router>(
    BuildContext context, {
    bool nullOk = false,
    bool rootRouter = false,
  }) {
    if (rootRouter) return Nuvigator.of(context, rootNuvigator: true).router;
    final router = Nuvigator.ofRouter<T>(context)?.getRouter<T>();
    assert(() {
      if (!nullOk && router == null) {
        throw FlutterError(
            'Router operation requested with a context that does not include a Router of the provided type.\n'
            'The context used to get the specified Router must be that of a '
            'widget that is a descendant of a Nuvigator widget that includes the desired Router.');
      }
      return true;
    }());
    return router;
  }

  HandleDeepLinkFn onDeepLinkNotFound;
  NuvigatorState _nuvigator;

  NuvigatorState get nuvigator => _nuvigator;

  set nuvigator(NuvigatorState newNuvigator) {
    _nuvigator = newNuvigator;
    for (final router in routers) {
      router.nuvigator = newNuvigator;
    }
  }

  WrapperFn get screensWrapper => null;

  List<Router> get routers => [];

  Map<String, ScreenRouteBuilder> get screensMap => {};

  /// Get the specified router that can be grouped in this router
  T getRouter<T extends Router>() {
    if (this is T) return this;
    for (final router in routers) {
      final r = router.getRouter<T>();
      if (r != null) return r;
    }
    return null;
  }

  Route getRoute<T>(RouteSettings settings, [ScreenType fallbackScreenType]) {
    final routeEntry = _getRouteEntryForDeepLink(settings.name);
    if (routeEntry == null) return null;
    final Map<String, Object> settingsArgs = (settings.arguments) ?? {};
    final Map<String, Object> computedArguments = {
      ...extractDeepLinkParameters(settings.name, routeEntry.routeName),
      ...settingsArgs,
    };
    final finalSettings = settings.copyWith(arguments: computedArguments);
    print(nuvigator);
    final route = routeEntry
        .screenBuilder(finalSettings)
        .fallbackScreenType(fallbackScreenType ?? nuvigator?.widget?.screenType)
        .toRoute(finalSettings);
    return route;
  }

  RouteEntry _getRouteEntryForDeepLink(String deepLink) {
    final routePath = screensMap.keys.firstWhere((routePath) {
      return pathToRegex(routePath).hasMatch(deepLink);
    }, orElse: () => null);
    if (routePath != null)
      return RouteEntry(routePath, _wrapScreenBuilder(screensMap[routePath]));
    for (final subRouter in routers) {
      final subRouterEntry = subRouter._getRouteEntryForDeepLink(deepLink);
      if (subRouterEntry != null) {
        return RouteEntry(
          subRouterEntry.routeName,
          _wrapScreenBuilder(subRouterEntry.screenBuilder),
        );
      }
    }
    return null;
  }

  ScreenRouteBuilder _wrapScreenBuilder(ScreenRouteBuilder screenRouteBuilder) {
    return (RouteSettings settings) =>
        screenRouteBuilder(settings).wrapWith(screensWrapper);
  }
}
