import 'package:flutter/material.dart';

import 'global_router.dart';

class NavigationService {
  NavigationService.of(this.context)
      : navigator = Navigator.of(context),
        rootNavigator = Navigator.of(context, rootNavigator: true);

  final BuildContext context;
  final NavigatorState navigator;
  final NavigatorState rootNavigator;

  bool pop<T>([T result]) {
    final isPopped = navigator.pop<T>(result);
    if (!isPopped && navigator != rootNavigator) {
      return parentPop<T>(result);
    }
    return isPopped;
  }

  Future<T> openDeepLink<T>(Uri url) {
    return GlobalRouter.of(context).openDeepLink<T>(url);
  }

  NavigationService get parent => NavigationService.of(navigator.context);

  Future<T> pushNamed<T>(String routeName, {Map<String, dynamic> arguments}) {
    final possibleRoute = navigator.widget
        .onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushNamed(routeName, arguments: arguments);
    }
    return navigator.pushNamed(routeName, arguments: arguments);
  }

  bool parentPop<T>([T result]) => parent.pop<T>(result);

  bool rootPop<T>([T result]) => rootNavigator.pop<T>(result);
}
