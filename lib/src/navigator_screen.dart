import 'package:flutter/material.dart';

import 'routers.dart';
import 'screen.dart';
import 'screen_widget.dart';

typedef GetScreenFn = Screen Function({String routeName});

class NavigatorScreen extends ScreenWidget {
  NavigatorScreen(ScreenContext screenContext, this.getScreenFn)
      : super(screenContext);

  NavigatorScreen.fromRouter(ScreenContext screenContext, Router router)
      : getScreenFn = router.getScreen,
        super(screenContext);

  final GetScreenFn getScreenFn;

  @override
  Widget build(BuildContext context) {
    final currentNavigatorKey =
        GlobalKey<NavigatorState>(debugLabel: screenContext.settings.name);
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
          }),
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
