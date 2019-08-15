import 'package:flutter/material.dart';

import 'global_router.dart';

class NavigationService {
  NavigationService.of(this.context)
      : navigator = Navigator.of(context),
        _rootNavigator = Navigator.of(context, rootNavigator: true);

  final BuildContext context;
  final NavigatorState navigator;
  final NavigatorState _rootNavigator;

  bool pop<T>([T result]) {
    final isPopped = navigator.pop<T>(result);
    if (!isPopped && navigator != _rootNavigator) {
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
      return parent.pushNamed<T>(routeName, arguments: arguments);
    }
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  bool parentPop<T>([T result]) => parent.pop<T>(result);

  bool rootPop<T>([T result]) => _rootNavigator.pop<T>(result);
}
