import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import '../nuvigator.dart';
import 'screen_route.dart';

class RouteEntry {
  RouteEntry(this.key, this.value);

  final RouteDef key;
  final ScreenRouteBuilder value;

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) => other is RouteEntry && other.key == key;
}

/// Router Interface. Provide a basic interface to communicate with other Router
/// components.
abstract class Router {
  ScreenRoute getScreen(RouteSettings settings);

  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) => null;

  Route getRoute(RouteSettings settings);
}

typedef ScreenRouteBuilder = ScreenRoute Function(RouteSettings settings);

abstract class BaseRouter implements Router {
  List<Router> get routers => [];

  Map<RouteDef, ScreenRouteBuilder> get screensMap;

  final String deepLinkPrefix = null;

  WrapperFn get screensWrapper => null;

  Future<String> getDeepLinkPrefix() async {
    return deepLinkPrefix ?? '';
  }

  @override
  ScreenRoute getScreen(RouteSettings settings) {
    final screen = _getScreen(settings);
    if (screen != null) return screen;

    for (Router router in routers) {
      final screen = router.getScreen(settings);
      if (screen != null) return screen.wrapWith(screensWrapper);
    }
    return null;
  }

  @override
  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) async {
    final thisDeepLinkPrefix = await getDeepLinkPrefix();
    final prefixRegex = RegExp('^$thisDeepLinkPrefix.*');
    if (prefixRegex.hasMatch(deepLink)) {
      final screen = await _getRouteEntryForDeepLink(deepLink);
      if (screen != null) return screen;
      for (final Router router in routers) {
        final newDeepLink = deepLink.replaceFirst(thisDeepLinkPrefix, '');
        final subRouterEntry =
            await router.getRouteEntryForDeepLink(newDeepLink);
        if (subRouterEntry != null) {
          final fullTemplate =
              thisDeepLinkPrefix + (subRouterEntry.key.deepLink ?? '');
          return RouteEntry(
            RouteDef(subRouterEntry.key.routeName, deepLink: fullTemplate),
            _wrapScreenBuilder(subRouterEntry.value),
          );
        }
      }
    }
    return null;
  }

  ScreenRouteBuilder _wrapScreenBuilder(ScreenRouteBuilder screenRouteBuilder) {
    return (RouteSettings settings) =>
        screenRouteBuilder(settings).wrapWith(screensWrapper);
  }

  ScreenRoute _getScreen(RouteSettings settings) {
    final screenBuilder = screensMap[RouteDef(settings.name)];
    if (screenBuilder == null) return null;
    return screenBuilder(settings).wrapWith(screensWrapper);
  }

  Future<RouteEntry> _getRouteEntryForDeepLink(String deepLink) async {
    final deepLinkPrefix = await getDeepLinkPrefix();
    for (var screenEntry in screensMap.entries) {
      final routeDef = screenEntry.key;
      final screenBuilder = screenEntry.value;
      final currentDeepLink = routeDef.deepLink;
      if (currentDeepLink == null) continue;
      final fullTemplate = deepLinkPrefix + currentDeepLink;
      final regExp = pathToRegExp(fullTemplate);
      if (regExp.hasMatch(deepLink)) {
        return RouteEntry(
          RouteDef(routeDef.routeName, deepLink: fullTemplate),
          _wrapScreenBuilder(screenBuilder),
        );
      }
    }
    return null;
  }

  @override
  Route getRoute(RouteSettings settings) {
    return getScreen(settings).toRoute(settings);
  }
}
