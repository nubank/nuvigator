import 'package:flutter/material.dart';

import 'routers.dart';
import 'screen.dart';
import 'screen_widget.dart';

typedef GetScreenFn = Screen Function({String routeName});

class NavigatorScreen extends ScreenWidget {
  NavigatorScreen(ScreenContext screenContext, this.getScreenFn)
      : super(screenContext);

  NavigatorScreen.fromRouter(ScreenContext screenContext, Router router)
      : this(screenContext, router.getScreen);

  final GetScreenFn getScreenFn;

  @override
  Widget build(BuildContext context) {
    return _NestedNavigator(
      screenContext: screenContext,
      getScreenFn: getScreenFn,
    );
  }
}

class _NestedNavigator extends StatefulWidget {
  const _NestedNavigator({this.screenContext, this.getScreenFn});

  final ScreenContext screenContext;
  final GetScreenFn getScreenFn;

  @override
  _NestedNavigatorState createState() => _NestedNavigatorState();
}

class _NestedNavigatorState extends State<_NestedNavigator> {
  GlobalKey<NavigatorState> currentNavigatorKey;

  @override
  void initState() {
    currentNavigatorKey = GlobalKey<NavigatorState>(
        debugLabel: widget.screenContext.settings.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !(await currentNavigatorKey.currentState.maybePop()),
      child: Navigator(
        initialRoute: widget.screenContext.settings.name,
        key: currentNavigatorKey,
        onGenerateRoute: (newSettings) {
          final routeSettings =
              _getRouteSettings(widget.screenContext.settings, newSettings);
          return _dispatchRoute(routeSettings);
        },
      ),
    );
  }

  Route _dispatchRoute(RouteSettings routeSettings) {
    final screen = widget.getScreenFn(routeName: routeSettings.name);
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
