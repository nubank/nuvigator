import 'package:flutter/material.dart';

import '../nuvigator.dart';
import 'helpers.dart';
import 'screen_route.dart';

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

class RoutePath {
  RoutePath(this.path, {this.prefix = false});

  final String path;
  final bool prefix;

  RoutePath copyWith({String path, bool prefix}) {
    return RoutePath(
      path ?? this.path,
      prefix: prefix ?? this.prefix,
    );
  }

  @override
  int get hashCode => hashList([path.hashCode, prefix.hashCode]);

  @override
  bool operator ==(Object other) {
    return other is RoutePath && other.path == path && other.prefix == prefix;
  }
}

typedef ScreenRouteBuilder = ScreenRoute Function(RouteSettings settings);
typedef HandleDeepLinkFn = Future<dynamic>
    Function(Router router, String deepLink, [dynamic args, bool isFromNative]);

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

class ScreenRouter<T extends Router> extends InheritedWidget {
  const ScreenRouter({Key key, @required this.router, @required Widget child})
      : assert(router != null),
        assert(child != null),
        super(key: key, child: child);

  final T router;

  static ScreenRouter<R> of<R extends Router>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScreenRouter<R>>();
  }

  @override
  bool updateShouldNotify(ScreenRouter oldWidget) {
    return oldWidget.router != router;
  }
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

  // Public Override API
  String get prefix => '';
  Map<RoutePath, ScreenRouteBuilder> get screensMap => {};
  List<Router> get routers => [];

  String get _prefix {
    // In case of Nuvigator being null, it means this Router is uncontextualized
    if (nuvigator == null || nuvigator.isRoot) {
      return prefix;
    }
    // TODO: We need to consider the parent RoutePath, and not the prefix
    final parentRouter = ScreenRouter.of(nuvigator.context);
    final parentPrefix = parentRouter.router._prefix;
    return parentPrefix + prefix;
  }

  set nuvigator(NuvigatorState newNuvigator) {
    _nuvigator = newNuvigator;
    for (final router in routers) {
      router.nuvigator = newNuvigator;
    }
  }

  WrapperFn get screensWrapper => null;

  // Used internally
  Map<RoutePath, ScreenRouteBuilder> get _prefixedScreensMap =>
      screensMap.map((k, v) => MapEntry(k.copyWith(path: _prefix + k.path), v));

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
      ...extractDeepLinkParameters(settings.name, routeEntry.routePath),
      ...settingsArgs,
    };
    final finalSettings = settings.copyWith(arguments: computedArguments);
    final route = routeEntry
        .screenBuilder(finalSettings)
        .fallbackScreenType(fallbackScreenType ?? nuvigator?.widget?.screenType)
        .toRoute(finalSettings, this);
    return route;
  }

  RouteEntry _getRouteEntryForDeepLink(String deepLink) {
    final routePath = _prefixedScreensMap.keys.firstWhere((routePath) {
      return pathMatches(deepLink, routePath);
    }, orElse: () => null);
    if (routePath != null)
      return RouteEntry(
          routePath, _wrapScreenBuilder(_prefixedScreensMap[routePath]));
    for (final subRouter in routers) {
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
    return (RouteSettings settings) =>
        screenRouteBuilder(settings).wrapWith(screensWrapper);
  }
}
