import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import '../nuvigator.dart';
import 'screen_route.dart';

class RouteEntry {
  RouteEntry({this.deepLink, this.template, this.routeName, this.screen});

  final String deepLink;
  final String template;
  final ScreenRoute screen;
  final String routeName;

  Map<String, String> get arguments =>
      _extractParameters(Uri.parse(deepLink), template);

  RouteSettings get settings =>
      RouteSettings(arguments: arguments, name: routeName);

  Map<String, String> _extractParameters(Uri url, String deepLinkTemplate) {
    final parameters = <String>[];
    final regExp = pathToRegExp(deepLinkTemplate, parameters: parameters);
    final match = regExp.matchAsPrefix(url.host + url.path);
    return extract(parameters, match)..addAll(url.queryParameters);
  }

  @override
  String toString() {
    return '$deepLink ($routeName - $template)';
  }

  @override
  int get hashCode => hashList([template, deepLink, routeName]);

  @override
  bool operator ==(dynamic other) {
    if (other is RouteEntry) {
      return other.deepLink == deepLink &&
          other.template == template &&
          other.routeName == routeName;
    }
    return false;
  }
}

/// Router Interface. Provide a basic interface to communicate with other Router
/// components.
abstract class Router {
  ScreenRoute getScreen({@required String routeName});

  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) => null;

  Route getRoute(RouteSettings settings);
}

abstract class BaseRouter implements Router {
  List<Router> get routers => [];

  Map<String, ScreenRoute> get screensMap;
  final String deepLinkPrefix = null;

  WrapperFn get screensWrapper => null;

  Future<String> getDeepLinkPrefix() async {
    return deepLinkPrefix ?? '';
  }

  @override
  ScreenRoute getScreen({@required String routeName}) {
    assert(routeName != null && routeName.isNotEmpty);

    final screen = _getScreen(routeName: routeName);
    if (screen != null) return screen;

    for (Router router in routers) {
      final screen = router.getScreen(routeName: routeName);
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
        final newUrl = deepLink.replaceFirst(thisDeepLinkPrefix, '');
        final subRouterEntry = await router.getRouteEntryForDeepLink(newUrl);
        if (subRouterEntry != null) {
          final fullTemplate = thisDeepLinkPrefix + subRouterEntry.template;
          return RouteEntry(
            screen: subRouterEntry.screen,
            template: fullTemplate,
            deepLink: deepLink,
            routeName: subRouterEntry.routeName,
          );
        }
      }
    }
    return null;
  }

  ScreenRoute _getScreen({@required String routeName}) {
    assert(routeName != null && routeName.isNotEmpty);

    final screen = screensMap[routeName];
    return screen?.wrapWith(screensWrapper);
  }

  Future<RouteEntry> _getRouteEntryForDeepLink(String deepLink) async {
    final deepLinkPrefix = await getDeepLinkPrefix();
    for (var screenEntry in screensMap.entries) {
      final screen = screenEntry.value;
      final currentDeepLink = screenEntry.value.deepLink;
      if (currentDeepLink == null) break;
      final fullTemplate = deepLinkPrefix + currentDeepLink;
      final regExp = pathToRegExp(fullTemplate);
      if (regExp.hasMatch(deepLink)) {
        return RouteEntry(
          deepLink: deepLink,
          template: fullTemplate,
          screen: screen,
          routeName: screenEntry.key,
        );
      }
    }
    return null;
  }

  @override
  Route getRoute(RouteSettings settings) {
    return getScreen(routeName: settings.name).toRoute(settings);
  }
}
