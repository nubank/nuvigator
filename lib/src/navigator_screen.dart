import 'package:flutter/material.dart';

import 'routers.dart';
import 'screen.dart';
import 'screen_widget.dart';

typedef GetScreenFn = Screen Function({String routeName});

class NavigatorScreen extends ScreenWidget {
  NavigatorScreen(
      this.currentNavigatorKey, ScreenContext screenContext, this.getScreenFn)
      : super(screenContext);

  NavigatorScreen.fromRouter(
    GlobalKey<NavigatorState> currentNavigatorKey,
    ScreenContext screenContext,
    Router router,
  ) : this(currentNavigatorKey, screenContext, router.getScreen);

  final GetScreenFn getScreenFn;
  final GlobalKey<NavigatorState> currentNavigatorKey;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !(await currentNavigatorKey.currentState.maybePop()),
      child: Navigator(
        initialRoute: screenContext.settings.name,
        key: currentNavigatorKey,
        onGenerateRoute: (newSettings) {
          final routeSettings =
              _getRouteSettings(screenContext.settings, newSettings);
          return _dispatchRoute(routeSettings);
        },
      ),
    );
  }

  Route _dispatchRoute(RouteSettings routeSettings) {
    final screen = getScreenFn(routeName: routeSettings.name);
    return screen?.toRoute(routeSettings);
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
