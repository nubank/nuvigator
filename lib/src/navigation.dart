import 'package:flutter/material.dart';

import 'global_router.dart';

abstract class NavigationService {
  NavigationService.of(this.context)
      : navigator = Navigator.of(context),
        rootNavigator = Navigator.of(context, rootNavigator: true);

  final BuildContext context;
  final NavigatorState navigator;
  final NavigatorState rootNavigator;
}

class Navigation extends NavigationService {
  Navigation.of(BuildContext context) : super.of(context);

  bool pop<T>([T result]) {
    if (!navigator.pop() && navigator != rootNavigator) {
      return parentPop<T>(result);
    }
    return true;
  }

  Future<T> openDeepLink<T>(Uri url) {
    return GlobalRouter.of(context).openDeepLink<T>(url);
  }

  Navigation parent() => Navigation.of(navigator.context);

  bool parentPop<T>([T result]) => parent().pop<T>(result);

  bool rootPop<T>([T result]) => rootNavigator.pop();
}
