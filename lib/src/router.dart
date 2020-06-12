import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:nuvigator/src/nuvigator_settings.dart';

import 'helpers.dart';
import 'nuvigator.dart';
import 'route_path.dart';
import 'screen_route.dart';
import 'screen_type.dart';

typedef ScreenRouteBuilder = ScreenRoute Function(NuRouteSettings settings);
typedef HandleDeepLinkFn = Future<dynamic>
    Function(Router router, String deepLink, [dynamic args, bool isFromNative]);

String encodeDeepLink(String path, Map<String, dynamic> params) {
  final queryParams = <String, dynamic>{};

  final interpolated = params.entries.fold<String>(path, (value, element) {
    final elementName = element.key;
    if (value.contains(':$element')) {
      return value.replaceAll(':$elementName', element.value);
    } else {
      queryParams[elementName] = element.value;
      return value;
    }
  });
  return queryParams.isNotEmpty
      ? interpolated + Uri(queryParameters: queryParams).toString()
      : interpolated;
}

class RouteEntry {
  RouteEntry(this.routePath, this.screenBuilder);

  final RoutePath routePath;
  final ScreenRouteBuilder screenBuilder;

  @override
  int get hashCode => routePath.hashCode;

  @override
  bool operator ==(Object other) =>
      other is RouteEntry && other.routePath == routePath;
}

abstract class Router {
  Router() {
    // Calling the getter here to cache the instances of the returned Routers
    _routers = routers;
  }

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

  // Public Override API
  String get deepLinkPrefix => '';

  Map<RoutePath, ScreenRouteBuilder> get screensMap => {};

  List<Router> get routers => [];

  WrapperFn get screensWrapper => null;

  String get scheme => NuvigatorSettings.appScheme;

  // Private Down below
  List<Router> _routers;

  String get _prefix => deepLinkPrefix;

  Map<RoutePath, ScreenRouteBuilder> get _prefixedScreensMap =>
      screensMap.map((k, v) => MapEntry(k.copyWith(path: _prefix + k.path), v));

  void install(NuvigatorState nuvigator) {
    assert(_nuvigator == null && nuvigator != null);
    _nuvigator = nuvigator;
    for (final router in _routers) {
      router.install(nuvigator);
    }
  }

  void uninstall() {
    for (final router in _routers) {
      router.uninstall();
    }
    _nuvigator = null;
  }

  /// Get the specified router that can be grouped in this router
  T getRouter<T extends Router>() {
    if (this is T) return this;
    for (final router in _routers) {
      final r = router.getRouter<T>();
      if (r != null) return r;
    }
    return null;
  }

  Route getRoute<T>(RouteSettings settings, [ScreenType fallbackScreenType]) {
    final scheme = Uri.parse(settings.name).scheme;
    final path = trimPrefix(settings.name, scheme + '://');
    final routeEntry = _getRouteEntryForDeepLink(path);
    if (routeEntry == null) return null;
    final nuRouteSettings = NuRouteSettings(
      name: path,
      scheme: scheme,
      pathParams: deepLinkPathParams(path, routeEntry.routePath),
      queryParams: deepLinkQueryParams(path),
      arguments: settings.arguments,
      routePath: routeEntry.routePath,
    );
    final route = routeEntry
        .screenBuilder(nuRouteSettings)
        .fallbackScreenType(fallbackScreenType ?? nuvigator?.widget?.screenType)
        .toRoute(nuRouteSettings);
    return route;
  }

  /// Same as nuvigator.openDeepLink()
  Future<R> openDeepLink<R extends Object>(String deepLink,
      [dynamic args, bool isFromNative]) {
    return nuvigator.openDeepLink<R>(deepLink, args, isFromNative);
  }

  /// Verify if THIS router can handle the deepLink, does not checks for routers
  /// up in the chain.
  bool canOpenDeepLink(String deepLink) {
    final scheme = Uri.parse(deepLink).scheme;
    final path = trimPrefix(deepLink, scheme + '://');
    return _getRouteEntryForDeepLink(path) != null;
  }

  RouteEntry _getRouteEntryForDeepLink(String deepLink) {
    final routePath = _prefixedScreensMap.keys.firstWhere((routePath) {
      return pathMatches(deepLink, routePath);
    }, orElse: () => null);
    if (routePath != null) {
      return RouteEntry(
        routePath,
        _wrapScreenBuilder(_prefixedScreensMap[routePath]),
      );
    }
    for (final subRouter in _routers) {
      final subRouterEntry = subRouter._getRouteEntryForDeepLink(deepLink);
      if (subRouterEntry != null) {
        return RouteEntry(
          subRouterEntry.routePath,
          _wrapScreenBuilder(subRouterEntry.screenBuilder),
        );
      }
    }
    return null;
  }

  String pathWithPrefix(String path) {
    return _prefix + path;
  }

  ScreenRouteBuilder _wrapScreenBuilder(ScreenRouteBuilder screenRouteBuilder) {
    return (NuRouteSettings settings) =>
        screenRouteBuilder(settings).wrapWith(screensWrapper);
  }
}
