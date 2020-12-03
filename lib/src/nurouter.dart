import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuvigator/src/deeplink.dart';

import '../nuvigator.dart';
import 'screen_route.dart';

typedef ScreenRouteBuilder = ScreenRoute<dynamic> Function(
    RouteSettings settings);

typedef HandleDeepLinkFn = Future<dynamic> Function(INuRouter router, Uri uri,
    [bool isFromNative, dynamic args]);

class RouteEntry {
  RouteEntry(this.key, this.screenRouteBuilder);

  final RouteDef key;
  final ScreenRouteBuilder screenRouteBuilder;

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) => other is RouteEntry && other.key == key;
}

abstract class INuRouter {
  void install(NuvigatorState nuvigator);

  void dispose();

  HandleDeepLinkFn get onDeepLinkNotFound;

  @deprecated
  T getRouter<T extends INuRouter>();

  Route<T> getRoute<T>({
    String deepLink,
    Map<String, dynamic> parameters,
    bool fromLegacyRouteName = false,
    ScreenType fallbackScreenType,
  });
}

abstract class NuRouter implements INuRouter {
  static T of<T extends NuRouter>(
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

  @override
  HandleDeepLinkFn get onDeepLinkNotFound => null;

  NuvigatorState _nuvigator;

  NuvigatorState get nuvigator => _nuvigator;

  @override
  void install(NuvigatorState nuvigator) {
    assert(_nuvigator == null);
    _nuvigator = nuvigator;
    for (final router in routers) {
      router.install(nuvigator);
    }
  }

  @override
  void dispose() {
    _nuvigator = null;
    for (final router in routers) {
      router.dispose();
    }
  }

  WrapperFn get screensWrapper => null;

  List<NuRouter> get routers => [];

  Map<RouteDef, ScreenRouteBuilder> get screensMap => {};

  String get deepLinkPrefix => '';

  /// Get the specified router that can be grouped in this router
  @override
  T getRouter<T extends INuRouter>() {
    // ignore: avoid_as
    if (this is T) return this as T;
    for (final router in routers) {
      final r = router.getRouter<T>();
      if (r != null) return r;
    }
    return null;
  }

  // region Deprecated methods
  @deprecated
  ScreenRoute _getScreen(RouteSettings settings) {
    final screenBuilder = screensMap[RouteDef(settings.name)];
    if (screenBuilder == null) return null;
    return screenBuilder(settings).wrapWith(screensWrapper);
  }

  @deprecated
  ScreenRoute getScreen(RouteSettings settings) {
    final screen = _getScreen(settings);
    if (screen != null) return screen;

    for (final router in routers) {
      final screen = router.getScreen(settings);
      if (screen != null) return screen.wrapWith(screensWrapper);
    }
    return null;
  }

  /// Deprecated: Prefer using getRoute
  @deprecated
  RouteEntry getRouteEntryForDeepLink(String deepLink) {
    final thisDeepLinkPrefix = deepLinkPrefix;
    // Looks for match in this Router screens
    for (var screenEntry in screensMap.entries) {
      final routeDef = screenEntry.key;
      final screenBuilder = screenEntry.value;
      final currentDeepLink = routeDef.deepLink;
      if (currentDeepLink == null) continue;
      final fullTemplate = deepLinkPrefix + currentDeepLink;
      if (DeepLinkParser(template: fullTemplate).matches(deepLink)) {
        return RouteEntry(
          RouteDef(routeDef.routeName, deepLink: fullTemplate),
          _wrapScreenBuilder(screenBuilder),
        );
      }
    }
    // If not found, iterates on the grouped routers
    for (final router in routers) {
      final newDeepLink = deepLink.replaceFirst(thisDeepLinkPrefix, '');
      final subRouterEntry = router.getRouteEntryForDeepLink(newDeepLink);
      if (subRouterEntry != null) {
        final fullTemplate =
            thisDeepLinkPrefix + (subRouterEntry.key.deepLink ?? '');
        return RouteEntry(
          RouteDef(subRouterEntry.key.routeName, deepLink: fullTemplate),
          _wrapScreenBuilder(subRouterEntry.screenRouteBuilder),
        );
      }
    }
    return null;
  }

  /// Deprecated: Prefer using [NuvigatorState.open]
  @deprecated
  Future<T> openDeepLink<T>(Uri url,
      [dynamic arguments, bool isFromNative = false]) async {
    if (this == nuvigator.rootRouter) {
      final routeEntry = getRouteEntryForDeepLink(url.toString());

      if (routeEntry == null) {
        if (onDeepLinkNotFound != null) {
          return await onDeepLinkNotFound(this, url, isFromNative, arguments);
        }
        return null;
      }

      final mapArguments = DeepLinkParser(
        template: routeEntry.key.deepLink,
      ).getParams(url.toString());

      if (isFromNative) {
        final route = _buildNativeRoute(routeEntry, mapArguments);
        return nuvigator.push<T>(route);
      }
      return nuvigator.pushNamed<T>(routeEntry.key.routeName,
          arguments: mapArguments);
    } else {
      return nuvigator.openDeepLink<T>(url, arguments);
    }
  }

  // endregion

  bool canOpenDeepLink(Uri url) {
    return getRouteEntryForDeepLink(url.toString()) != null;
  }

  /// From a deepLink (plus some option parameters) get a Route.
  @override
  Route<T> getRoute<T>({
    String deepLink,
    Object parameters,
    @deprecated bool fromLegacyRouteName = false,
    ScreenType fallbackScreenType,
  }) {
    if (fromLegacyRouteName) {
      final settings = RouteSettings(name: deepLink, arguments: parameters);
      return getScreen(settings)
          ?.fallbackScreenType(fallbackScreenType)
          ?.toRoute(settings);
    }

    // 1. Get ScreeRouter for DeepLink
    final routeEntry = getRouteEntryForDeepLink(deepLink);
    if (routeEntry == null) {
      return null;
    }
    // 2. Build NuRouteSettings
    final settings =
        DeepLinkParser(template: routeEntry.key.deepLink).toNuRouteSettings(
      deepLink: deepLink,
      arguments: parameters,
    );
    // 3. Convert ScreenRoute to Route
    return routeEntry
        .screenRouteBuilder(settings)
        .wrapWith(screensWrapper)
        .fallbackScreenType(fallbackScreenType)
        .toRoute(settings);
  }

  ScreenRouteBuilder _wrapScreenBuilder(ScreenRouteBuilder screenRouteBuilder) {
    return (RouteSettings settings) =>
        screenRouteBuilder(settings).wrapWith(screensWrapper);
  }

  // When building a native route we assume we already the first route in the stack
  // that corresponds to the backdrop/invisible component. This allows for the
  // route animation being handled by the Flutter instead of the Native App.
  Route _buildNativeRoute(
      RouteEntry routeEntry, Map<String, String> arguments) {
    final routeSettings = RouteSettings(
      name: routeEntry.key.routeName,
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
}
