import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import '../nuvigator.dart';
import 'screen_route.dart';

String deepLinkString(Uri url) => url.host + url.path;

Type _typeOf<T>() => T;

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

class RouterProvider<T extends Router> extends InheritedWidget {
  const RouterProvider({@required this.router, @required Widget child})
      : super(child: child);

  final T router;

  @override
  bool updateShouldNotify(RouterProvider oldWidget) {
    return oldWidget.router != router;
  }
}

/// Router Interface. Provide a basic interface to communicate with other Router
/// components.
abstract class Router {
  NuvigatorState nuvigator; // Nuvigator in which this Router is being used

  static T of<T extends Router>(BuildContext context) {
    final type = _typeOf<RouterProvider<T>>();
    final RouterProvider<T> provider =
        context.inheritFromWidgetOfExactType(type);
    return provider?.router;
  }

  Future<T> openDeepLink<T>(Uri url,
      [dynamic arguments, bool isFromNative = false]);

  ScreenRoute getScreen(RouteSettings settings);

  Future<bool> canOpenDeepLink(Uri url);

  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) => null;

  Route getRoute(RouteSettings settings);
}

typedef ScreenRouteBuilder = ScreenRoute Function(RouteSettings settings);

abstract class BaseRouter implements Router {
  List<Router> get routers => [];

  Map<RouteDef, ScreenRouteBuilder> get screensMap;

  @override
  NuvigatorState nuvigator;
  final String deepLinkPrefix = null;
  HandleDeepLinkFn onDeepLinkNotFound;
  ScreenRoute Function(RouteSettings settings) onScreenNotFound;

  WrapperFn get screensWrapper => null;

  Future<String> get getDeepLinkPrefix async => deepLinkPrefix ?? '';

  @override
  ScreenRoute getScreen(RouteSettings settings) {
    final screen = _getScreen(settings);
    if (screen != null) return screen;

    for (Router router in routers) {
      final screen = router.getScreen(settings);
      if (screen != null) return screen.wrapWith(screensWrapper);
    }
    if (onScreenNotFound != null)
      return onScreenNotFound(settings)
          ?.fallbackScreenType(nuvigator.widget.screenType);
    return null;
  }

  @override
  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) async {
    final thisDeepLinkPrefix = await getDeepLinkPrefix;
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
    final deepLinkPrefix = await getDeepLinkPrefix;
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

  @override
  Future<bool> canOpenDeepLink(Uri url) async {
    return (await getRouteEntryForDeepLink(deepLinkString(url))) != null;
  }

  @override
  Future<T> openDeepLink<T>(Uri url,
      [dynamic arguments, bool isFromNative = false]) async {
    final routeEntry = await getRouteEntryForDeepLink(deepLinkString(url));

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
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await SystemNavigator.pop();
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

class FlowRouter<T extends Router, R extends Object> extends BaseRouter {
  FlowRouter(
    this.baseRouter, {
    this.screensType,
    this.initialScreenType,
    this.wrapper,
  });

  final ScreenType initialScreenType;
  final ScreenType screensType;
  final Router baseRouter;
  final WrapperFn wrapper;

  @override
  ScreenRoute getScreen(RouteSettings settings) {
    final firstScreen = baseRouter.getScreen(settings);
    if (firstScreen == null) return null;
    return FlowRoute<T, R>(
      screenType: initialScreenType,
      nuvigator: Nuvigator<T>(
        router: baseRouter,
        initialRoute: settings.name,
        screenType: screensType,
        wrapper: wrapper,
        initialArguments: settings.arguments,
      ),
    );
  }

  @override
  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) async {
    return await baseRouter.getRouteEntryForDeepLink(deepLink);
  }

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => null;
}
