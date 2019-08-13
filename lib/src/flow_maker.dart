import 'package:flutter/material.dart';

import 'routers.dart';
import 'screen.dart';
import 'transition_type.dart';

class FlowMaker<T extends Object> {
  FlowMaker(this.router,
      {this.generateProviders,
      this.initialScreen,
      this.transitionType = TransitionType.card});

  final Router router;
  final ProvidersGeneratorFn generateProviders;
  final String initialScreen;
  final TransitionType transitionType;

  Screen start() {
    return getNavigatorScreen(initialScreen);
  }

  Screen getNavigatorScreen(String routeName) {
    // Matcher for the parent router

    final firstScreen = router.getScreen(routeName: routeName);
    if (firstScreen == null) return null;

    // Wraps everything into a Screen.card
    // flows usually are present this way, but we can work around this
    return Screen(
        generateProviders: generateProviders,
        transitionType: transitionType,
        screenBuilder: (screenContext) {
          final newScreenContext = ScreenContext(
              settings: screenContext.settings.copyWith(name: routeName),
              context: screenContext.context);
          return _childNavigator(newScreenContext);
        });
  }

  Widget _childNavigator(ScreenContext screenContext) {
    final currentNavigatorKey = GlobalKey<NavigatorState>();
    return WillPopScope(
      // We need to circuit break the pop behaviour to try to pop this navigator
      // before the parent
      onWillPop: () async =>
          !(await currentNavigatorKey.currentState.maybePop()),
      child: Navigator(
          initialRoute: screenContext.settings.name,
          key: currentNavigatorKey,
          onGenerateRoute: (newSettings) {
            final routeSettings =
                _getRouteSettings(screenContext.settings, newSettings);
            return _dispatchRoute(routeSettings, screenContext);
          }),
    );
  }

  Route _dispatchRoute(
      RouteSettings routeSettings, ScreenContext screenContext) {
    // Try to find a child screen
    final screen = router.getScreen(routeName: routeSettings.name);
    // If we can't find the route here, let's check if out parents now something :)
    if (screen == null) {
      Navigator.of(screenContext.context)
          .pushNamed(routeSettings.name, arguments: routeSettings.arguments);
      return null;
    } else {
      // If the screen is ours, let's build a regular Route for it!
      return screen.toRoute(routeSettings);
    }
  }

  RouteSettings _getRouteSettings(
      RouteSettings initialSettings, RouteSettings newSettings) {
    if (initialSettings.name == newSettings.name) {
      return newSettings.copyWith(arguments: initialSettings.arguments);
    } else {
      return newSettings;
    }
  }
}
