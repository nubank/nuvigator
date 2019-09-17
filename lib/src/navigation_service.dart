import 'package:flutter/material.dart';

import 'routers.dart';

class NavigationService {
  NavigationService.of(this.context)
      : _navigator = Navigator.of(context),
        _rootNavigator = Navigator.of(context, rootNavigator: true);

  final BuildContext context;
  final NavigatorState _navigator;
  final NavigatorState _rootNavigator;

  NavigationService get parent => NavigationService.of(_navigator.context);

  Future<T> pushNamed<T extends Object>(String routeName, {Object arguments}) {
    final possibleRoute = _navigator.widget
        .onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushNamed<T>(routeName, arguments: arguments);
    }
    return _navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      String routeName,
      {Object arguments,
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
      {Object arguments}) {
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
      {Object arguments,
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

  void popUntil(RoutePredicate predicate) {
    _navigator.popUntil(predicate);
  }

  bool parentPop<T extends Object>([T result]) => parent.pop<T>(result);

  bool rootPop<T extends Object>([T result]) => _rootNavigator.pop<T>(result);
}

class Nuvigator<T extends Router> extends Navigator {
  Nuvigator({@required this.router, Key key, @required String initialRoute})
      : super(
            onGenerateRoute: router.getRoute,
            key: key,
            initialRoute: initialRoute);

  final T router;

  static NuvigatorState<T> of<T extends Router>(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<NuvigatorState>());
  }

  @override
  NavigatorState createState() {
    return NuvigatorState<T>();
  }
}

class NuvigatorState<T extends Router> extends NavigatorState {
  NavigatorState get _rootNavigator =>
      Navigator.of(context, rootNavigator: true);

  @override
  Nuvigator get widget => super.widget;

  T get router => widget.router;

  @override
  Future<T> pushNamed<T extends Object>(String routeName, {Object arguments}) {
    final possibleRoute = widget
        .onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushNamed<T>(routeName, arguments: arguments);
    }
    return super.pushNamed<T>(routeName, arguments: arguments);
  }

  @override
  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      String routeName,
      {Object arguments,
      TO result}) {
    final possibleRoute = widget
        .onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushReplacementNamed<T, TO>(routeName,
          arguments: arguments, result: result);
    }
    return super.pushReplacementNamed<T, TO>(routeName,
        arguments: arguments, result: result);
  }

  @override
  Future<T> pushNamedAndRemoveUntil<T extends Object>(
      String newRouteName, RoutePredicate predicate,
      {Object arguments}) {
    final possibleRoute = widget.onGenerateRoute(
        RouteSettings(name: newRouteName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushNamedAndRemoveUntil<T>(newRouteName, predicate,
          arguments: arguments);
    }
    return super.pushNamedAndRemoveUntil<T>(newRouteName, predicate,
        arguments: arguments);
  }

  @override
  Future<T> popAndPushNamed<T extends Object, TO extends Object>(
      String routeName,
      {Object arguments,
      TO result}) {
    final possibleRoute = widget
        .onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.popAndPushNamed<T, TO>(routeName,
          arguments: arguments, result: result);
    }
    return super.popAndPushNamed<T, TO>(routeName,
        arguments: arguments, result: result);
  }

  @override
  bool pop<T extends Object>([T result]) {
    final isPopped = super.pop<T>(result);
    if (!isPopped && super != _rootNavigator) {
      return parentPop<T>(result);
    }
    return isPopped;
  }

  bool parentPop<T extends Object>([T result]) => parent.pop<T>(result);

  bool rootPop<T extends Object>([T result]) => _rootNavigator.pop<T>(result);

  NuvigatorState get parent => Nuvigator.of(context);
}
