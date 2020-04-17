import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:recase/recase.dart';

import '../nuvigator.dart';
import 'screen_route.dart';

typedef ScreenRouteBuilder = ScreenRoute Function(RouteSettings settings);
typedef HandleDeepLinkFn = Future<dynamic>
    Function(Router router, String deepLink, [dynamic args, bool isFromNative]);

RegExp pathToRegex(String path, {List<String> parameters}) {
  final prefix = path.endsWith('*');
  if (prefix) {
    return pathToRegExp(path.substring(0, path.length - 1),
        parameters: parameters, prefix: true);
  } else {
    return pathToRegExp(path, parameters: parameters);
  }
}

Map<String, String> extractDeepLinkParameters(String deepLink, String path) {
  final parameters = <String>[];
  final regExp = pathToRegex(path, parameters: parameters);
  final match = regExp.matchAsPrefix(deepLink);
  final parametersMap = extract(parameters, match)
    ..addAll(Uri.parse(deepLink).queryParameters);
  final camelCasedParametersMap = parametersMap.map((k, v) {
    return MapEntry(ReCase(k).camelCase, v);
  });
  return {...parametersMap, ...camelCasedParametersMap};
}

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
    final routeEntry = getRouteEntryForDeepLink(settings.name);
    if (routeEntry == null) return null;
    final Map<String, Object> settingsArgs = (settings.arguments) ?? {};
    final Map<String, Object> computedArguments = {
      'nuvigator/deepLink': settings.name,
      ...settingsArgs,
      ...extractDeepLinkParameters(settings.name, routeEntry.routeName)
    };
    final finalSettings = settings.copyWith(arguments: computedArguments);
    print(nuvigator);
    final route = routeEntry
        .screenBuilder(finalSettings)
        .fallbackScreenType(fallbackScreenType ?? nuvigator?.widget?.screenType)
        .toRoute(finalSettings);
    return route;
  }

  bool canOpenDeepLink(String deepLink) {
    return getRouteEntryForDeepLink(deepLink) != null;
  }

  Future<T> openDeepLink<T>(String deepLink,
      [dynamic arguments, bool isFromNative = false]) async {
    return nuvigator.openDeepLink<T>(deepLink, arguments);
  }

  RouteEntry getRouteEntryForDeepLink(String deepLink) {
    final routePath = screensMap.keys.firstWhere((routePath) {
      return pathToRegex(routePath).hasMatch(deepLink);
    }, orElse: () => null);
    if (routePath != null)
      return RouteEntry(routePath, _wrapScreenBuilder(screensMap[routePath]));
    for (final subRouter in routers) {
      final subRouterEntry = subRouter.getRouteEntryForDeepLink(deepLink);
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

Router entryPointRouter(String deepLink, ScreenRouteBuilder builder) {
  return GenericRouter(screensMap: {
    deepLink: builder,
  });
}
