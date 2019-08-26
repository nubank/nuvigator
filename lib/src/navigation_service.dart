import 'package:flutter/material.dart';

class NavigationService {
  NavigationService.of(this.context)
      : _navigator = Navigator.of(context),
        _rootNavigator = Navigator.of(context, rootNavigator: true);

  final BuildContext context;
  final NavigatorState _navigator;
  final NavigatorState _rootNavigator;

  NavigationService get parent => NavigationService.of(_navigator.context);

  Future<T> pushNamed<T extends Object>(String routeName,
      {Map<String, dynamic> arguments}) {
    final possibleRoute = _navigator.widget
        .onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushNamed<T>(routeName, arguments: arguments);
    }
    return _navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      String routeName,
      {Map<String, dynamic> arguments,
      TO result}) {
    final possibleRoute = _navigator.widget
        .onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushReplacementNamed<T, TO>(routeName,
          arguments: arguments, result: result);
    }
    return _navigator.pushReplacementNamed<T, TO>(routeName,
        arguments: arguments, result: result);
  }

  Future<T> pushNamedAndRemoveUntil<T extends Object>(
      String routeName, RoutePredicate predicate,
      {Map<String, dynamic> arguments}) {
    final possibleRoute = _navigator.widget
        .onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushNamedAndRemoveUntil<T>(routeName, predicate,
          arguments: arguments);
    }
    return _navigator.pushNamedAndRemoveUntil<T>(routeName, predicate,
        arguments: arguments);
  }

  Future<T> popAndPushNamed<T extends Object, TO extends Object>(
      String routeName,
      {Map<String, dynamic> arguments,
      TO result}) {
    final possibleRoute = _navigator.widget
        .onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.popAndPushNamed<T, TO>(routeName,
          arguments: arguments, result: result);
    }
    return _navigator.popAndPushNamed<T, TO>(routeName,
        arguments: arguments, result: result);
  }

  bool pop<T extends Object>([T result]) {
    final isPopped = _navigator.pop<T>(result);
    if (!isPopped && _navigator != _rootNavigator) {
      return parentPop<T>(result);
    }
    return isPopped;
  }

  bool parentPop<T extends Object>([T result]) => parent.pop<T>(result);

  bool rootPop<T extends Object>([T result]) => _rootNavigator.pop<T>(result);
}
