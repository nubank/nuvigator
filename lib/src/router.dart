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
/// components. Usually you would want to extend the [BaseRouter] instead.
abstract class Router {
  ScreenRoute getScreen(RouteSettings settings);

  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) => null;

  Route getRoute(RouteSettings settings);
}

typedef ScreenRouteBuilder = ScreenRoute Function(RouteSettings settings);

/// Router with basic features implemented that can be extended to create custom
/// Routers.
///
/// Relevant options that can be configured in the base Router are:
/// - [deepLinkPrefix] will be used to prefix all deepLinks of the configured
/// Routes or GroupedRouters in this Router.
/// - [screensWrapper] a function that will be invoked to wrap each screen presented
/// by this Router of by any of it's GroupedRouters. (note that this function is going be
/// called one time per screen, and not just one time at the router creation)
///
/// {@tool sample}
/// Sample usage of [BaseRouter] with [NuRouter]
///
/// ```dart
/// @NuRouter()
/// class ExampleRouter extends BaseRouter {
///   @NuRoute()
///   ScreenRoute profile() => ScreenRoute(
///     builder: (_) => ProfileScreen(),
///   );
///
///   @NuRouter()
///   Example2Router example2Router = Example2Router();
///
///   @override
///   Map<RouteDef, ScreenRouteBuilder> get screensMap => _$exampleScreensMap(this);
///   @override
///   List<Router> routers = _$exampleMainRoutersList(this);
/// }
/// ```
/// {@end-tool}
///
/// The required fields to be implemented are [screensMap] and (optionally) [routers]
/// usually those getters are going to be generated automatically by the generator,
/// however it's possible to implement they manually if you don't want to rely on
/// generators.
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

/// Wrapper around another Router that will make possible to dynamically create
/// nested Nuvigators based on routes that are reached inside of it.
///
/// [baseRouter] is the Router that will be used by the nested Nuvigator and also to
/// have it's Routes and deepLinks exposed just like a regular Grouped Router.
/// [wrapper] will be used as the [Nuvigator.wrapper] function when instantiating it
/// [screensType] will be used as the [Nuvigator.screenType]
/// [initialScreenType] will be use to determine the screenType of the first screen
/// presented, if omitted it will fallback to the screenType of the parent Nuvigator.
///
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
