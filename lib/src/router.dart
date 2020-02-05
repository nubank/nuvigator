import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import '../nuvigator.dart';
import 'screen_route.dart';

typedef ScreenRouteBuilder = ScreenRoute Function(RouteSettings settings);

String deepLinkString(Uri url) => url.host + url.path;

typedef HandleDeepLinkFn = Future<dynamic> Function(Router router, Uri uri,
    [bool isFromNative, dynamic args]);

class RouteEntry {
  RouteEntry(this.key, this.value);

  final RouteDef key;
  final ScreenRouteBuilder value;

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) => other is RouteEntry && other.key == key;
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
  ScreenRoute Function(RouteSettings settings) onScreenNotFound;
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

  Map<RouteDef, ScreenRouteBuilder> get screensMap => {};

  String get deepLinkPrefix => '';

  /// Get the specified router that can be grouped in this router
  T getRouter<T extends Router>() {
    if (this is T) return this;
    for (final router in routers) {
      final r = router.getRouter<T>();
      if (r != null) return r;
    }
    return null;
  }

  ScreenRoute getScreen(RouteSettings settings) {
    final screen = _getScreen(settings);
    if (screen != null) return screen;

    for (Router router in routers) {
      final screen = router.getScreen(settings);
      if (screen != null) return screen.wrapWith(screensWrapper);
    }
    if (onScreenNotFound != null) return onScreenNotFound(settings);
    return null;
  }

  RouteEntry getRouteEntryForDeepLink(String deepLink) {
    final thisDeepLinkPrefix = deepLinkPrefix;
    final prefixRegex = RegExp('^$thisDeepLinkPrefix.*');
    if (prefixRegex.hasMatch(deepLink)) {
      final screen = _getRouteEntryForDeepLink(deepLink);
      if (screen != null) return screen;
      for (final Router router in routers) {
        final newDeepLink = deepLink.replaceFirst(thisDeepLinkPrefix, '');
        final subRouterEntry = router.getRouteEntryForDeepLink(newDeepLink);
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

  String getInitialRoute(String deepLinkOrRouteName) {
    final maybeDeepLinkRoute = getRouteEntryForDeepLink(deepLinkOrRouteName);

    return maybeDeepLinkRoute != null
        ? maybeDeepLinkRoute.key.routeName
        : deepLinkOrRouteName;
  }

  bool canOpenDeepLink(Uri url) {
    return getRouteEntryForDeepLink(deepLinkString(url)) != null;
  }

  Future<T> openDeepLink<T>(Uri url,
      [dynamic arguments, bool isFromNative = false]) async {
    if (this == nuvigator.rootRouter) {
      final routeEntry = getRouteEntryForDeepLink(deepLinkString(url));

      if (routeEntry == null) {
        if (onDeepLinkNotFound != null)
          return await onDeepLinkNotFound(this, url, isFromNative, arguments);
        return null;
      }

      final mapArguments = _extractParameters(url, routeEntry.key.deepLink);
      if (isFromNative) {
        final route = _buildNativeRoute(routeEntry, mapArguments);
        return nuvigator.push<T>(route);
      }
      return nuvigator.pushNamed<T>(routeEntry.key.routeName,
          arguments: mapArguments);
    }
    return nuvigator.openDeepLink<T>(url, arguments);
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

  RouteEntry _getRouteEntryForDeepLink(String deepLink) {
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

  // When building a native route we assume we already the first route in the stack
  // that corresponds to the backdrop/invisible component. This allows for the
  // route animation being handled by the Flutter instead of the Native App.
  Route _buildNativeRoute(
      RouteEntry routeEntry, Map<String, String> arguments) {
    final routeSettings = RouteSettings(
      name: routeEntry.key.routeName,
      isInitialRoute: false,
      arguments: arguments,
    );
    final screenRoute = getScreen(routeSettings)
        .fallbackScreenType(nuvigator.widget.screenType);
    final route = screenRoute.toRoute(routeSettings);
    route.popped.then<dynamic>((dynamic _) async {
      if (nuvigator.stateTracker.stack.length == 1) {
        // We only have the backdrop route in the stack
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await SystemNavigator.pop();
      }
    });
    return route;
  }

  Map<String, String> _extractParameters(Uri url, String deepLinkTemplate) {
    final parameters = <String>[];
    final regExp = pathToRegExp(deepLinkTemplate, parameters: parameters);
    final match = regExp.matchAsPrefix(deepLinkString(url));
    return extract(parameters, match)..addAll(url.queryParameters);
  }
}
