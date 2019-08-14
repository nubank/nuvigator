import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import 'flow_maker.dart';
import 'screen.dart';
import 'transition_type.dart';

class DeepLinkFlow {
  DeepLinkFlow({this.template, this.path, this.routeName});

  final String template;
  final String path;
  final String routeName;
}

// Base Router class. Provide a basic interface and a helper to build Routes from
// Screens.
abstract class Router {
  Screen getScreen({String routeName});

  Future<DeepLinkFlow> getDeepLinkFlowForUrl(String url) => null;
}

// Application Router class. Provides a basic interface and helper to handle
// deepLinks and get routes.
abstract class AppRouter {
  Future<bool> canOpenDeepLink(Uri url);

  Future<T> openDeepLink<T>(Uri url, [dynamic arguments]);

  Route getRoute(RouteSettings settings);
}

// Simplest type of router. It consists of two Maps, one for RouteName -> Screen
// and one for DeepLinks => RouteName. It will try to match against those to find
// a Screen.
abstract class SimpleRouter implements Router {
  final Map<String, Screen> screensMap = {};
  final Map<String, String> deepLinksMap = {};
  final String deepLinkPrefix = null;
  final ProvidersGeneratorFn generateProviders = null;

  Future<String> getDeepLinkPrefix() async {
    return deepLinkPrefix ?? '';
  }

  @override
  Screen getScreen({@required String routeName}) {
    assert(routeName != null && routeName.isNotEmpty);

    final screen = screensMap[routeName];
    return screen?.withProviders(generateProviders);
  }

  @override
  Future<DeepLinkFlow> getDeepLinkFlowForUrl(String url) async {
    final deepLinkPrefix = await getDeepLinkPrefix();
    for (var deepLinkEntry in deepLinksMap.entries) {
      final fullTemplate = deepLinkPrefix + deepLinkEntry.key;
      final regExp = pathToRegExp(fullTemplate);
      if (regExp.hasMatch(url))
        return DeepLinkFlow(
          path: url,
          template: fullTemplate,
          routeName: deepLinkEntry.value,
        );
    }
    return null;
  }

  FlowRouter flowRouter(
      {ProvidersGeneratorFn generateProviders, String initialScreen}) {
    return FlowRouter(this,
        generateFlowProviders: generateProviders, initialScreen: initialScreen);
  }
}

// More complex router that in addition to the features provided by the SimpleRouter
// it can contains a list of delegate Routers, that will try to match against.
// This router is used to create a "merge" Router of several other Routers.
class GroupRouter extends SimpleRouter {
  List<Router> routers = [];

  @override
  Screen getScreen({@required String routeName}) {
    assert(routeName != null && routeName.isNotEmpty);

    final screen = super.getScreen(routeName: routeName);
    if (screen != null) return screen;

    for (Router router in routers) {
      final screen = router.getScreen(routeName: routeName);
      if (screen != null) return screen;
    }
    return null;
  }

  @override
  Future<DeepLinkFlow> getDeepLinkFlowForUrl(String url) async {
    final thisDeepLinkPrefix = await getDeepLinkPrefix();
    final prefixRegex = RegExp('^$thisDeepLinkPrefix.*');
    if (prefixRegex.hasMatch(url)) {
      final deepLinkFlow = await super.getDeepLinkFlowForUrl(url);
      if (deepLinkFlow != null) return deepLinkFlow;

      for (final Router router in routers) {
        final newUrl = url.replaceFirst(thisDeepLinkPrefix, '');
        final subDeepLinkFlow = await router.getDeepLinkFlowForUrl(newUrl);
        if (subDeepLinkFlow != null) {
          final fullTemplate = thisDeepLinkPrefix + subDeepLinkFlow.template;
          return DeepLinkFlow(
            template: fullTemplate,
            path: url,
            routeName: subDeepLinkFlow.routeName,
          );
        }
      }
    }
    return null;
  }
}

// Special type of Router that will try to find the screen in it's provided
// baseRouter, but instead will return a nested Navigator.
// The first screen being the found screen, and at each new push it will
// look into for the new Screen again in it's baseRouter. This should be used when
// you have a more complex flow, composed of multiple screens creating a "journey".
// this router already handles the pop mechanism for you. Also if it does not find
// the route in itself it will dispatch to it's parent Navigator the opportunity
// to match it.
class FlowRouter<T extends Object> implements Router {
  FlowRouter(this.baseRouter,
      {ProvidersGeneratorFn generateFlowProviders,
      String initialScreen,
      TransitionType transitionType = TransitionType.card})
      : flowMaker = FlowMaker(baseRouter,
            generateProviders: generateFlowProviders,
            initialScreen: initialScreen,
            transitionType: transitionType);

  final Router baseRouter;
  final FlowMaker flowMaker;

  Screen start() {
    return flowMaker.start();
  }

  @override
  Screen getScreen({String routeName}) {
    return flowMaker.getNavigatorScreen(routeName);
  }

  @override
  Future<DeepLinkFlow> getDeepLinkFlowForUrl(String url) =>
      baseRouter.getDeepLinkFlowForUrl(url);
}
