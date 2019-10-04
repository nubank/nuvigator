import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import 'routers.dart';

class Nuvigator<T extends Router> extends Navigator {
  Nuvigator(
      {@required this.router,
      @required String initialRoute,
      Key key,
      this.screenType = materialScreenType,
      this.initialArguments})
      : super(
            onGenerateRoute: (settings) {
              var finalSettings = settings;
              if (settings.isInitialRoute &&
                  settings.name == initialRoute &&
                  settings.arguments == null) {
                finalSettings = settings.copyWith(arguments: initialArguments);
              }
              return router
                  .getScreen(routeName: finalSettings.name)
                  .fallbackScreenType(screenType)
                  .toRoute(finalSettings);
            },
            key: (router is GlobalRouter) ? router.nuvigatorKey : key,
            initialRoute: initialRoute);

//  static Nuvigator Function(ScreenContext sc) screen({
//    @required Router router,
//    @required String initialRoute,
//    Key key,
//    ScreenType screenType = materialScreenType,
//  }) {
//    return Nuvigator(
//        router: router, initialRoute: initialRoute, screenType: screenType);
//  }

  final T router;
  final Object initialArguments;
  final ScreenType screenType;

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
    final possibleRoute = widget.router.getScreen(routeName: routeName);
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
    final possibleRoute = widget.router.getScreen(routeName: routeName);
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
    final possibleRoute = widget.router.getScreen(routeName: newRouteName);
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
    final possibleRoute = widget.router.getScreen(routeName: routeName);
    if (possibleRoute == null) {
      return parent.popAndPushNamed<T, TO>(routeName,
          arguments: arguments, result: result);
    }
    return super.popAndPushNamed<T, TO>(routeName,
        arguments: arguments, result: result);
  }

  @override
  Future<bool> maybePop<T extends Object>([T result]) async {
    final willNotPop = await super.maybePop<T>(result);
    if (!willNotPop) return parent?.maybePop<T>(result);
    return willNotPop;
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

  /// R is the return value
  Future<R> navigate<R, T>(ScreenRoute<T, R> screenRoute) {
    return pushNamed<R>(screenRoute.routeName, arguments: screenRoute.params);
  }

  NuvigatorState get parent => Nuvigator.of(context);

  @override
  Widget build(BuildContext context) {
    if (widget.router is GlobalRouter) {
      return GlobalRouterProvider(
          globalRouter: widget.router, child: super.build(context));
    }
    return super.build(context);
  }
}

class ScreenRoute<T extends Object, R extends Object> {
  ScreenRoute(this.routeName, [this.params]);

  final String routeName;
  final T params;
}
