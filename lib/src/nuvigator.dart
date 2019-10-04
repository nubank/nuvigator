import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import 'routers.dart';
import 'screen_route.dart';

class Nuvigator<T extends Router> extends Navigator {
  Nuvigator({
    @required this.router,
    @required String initialRoute,
    Key key,
    this.screenType = materialScreenType,
    this.wrapperFn,
    this.initialArguments,
  }) : super(
          onGenerateRoute: (settings) {
            var finalSettings = settings;
            if (settings.isInitialRoute &&
                settings.name == initialRoute &&
                settings.arguments == null &&
                initialArguments != null) {
              finalSettings = settings.copyWith(arguments: initialArguments);
            }
            return router
                .getScreen(routeName: finalSettings.name)
                .fallbackScreenType(screenType)
                .toRoute(finalSettings);
          },
          key: (router is GlobalRouter) ? router.nuvigatorKey : key,
          initialRoute: initialRoute,
        );

  Nuvigator screenBuilder(ScreenContext screenContext) {
    return withInitialArguments(screenContext.settings.arguments);
  }

  Nuvigator withInitialArguments(Object initialArguments) {
    return Nuvigator(
      initialRoute: initialRoute,
      router: router,
      screenType: screenType,
      wrapperFn: wrapperFn,
      initialArguments: initialArguments,
      key: key,
    );
  }

  final T router;
  final Object initialArguments;
  final ScreenType screenType;
  final WrapperFn wrapperFn;

  Nuvigator call(ScreenContext screenContext) {
    return screenBuilder(screenContext);
  }

  static NuvigatorState<T> of<T extends Router>(BuildContext context,
      {bool rootNuvigator = false}) {
    return rootNuvigator
        ? context.rootAncestorStateOfType(const TypeMatcher<NuvigatorState>())
        : context.ancestorStateOfType(const TypeMatcher<NuvigatorState>());
  }

  @override
  NavigatorState createState() {
    return NuvigatorState<T>();
  }
}

class NuvigatorState<T extends Router> extends NavigatorState {
  NuvigatorState get _rootNuvigator =>
      Nuvigator.of(context, rootNuvigator: true) ?? this;

  @override
  Nuvigator get widget => super.widget;

  T get router => widget.router;

  @override
  Future<T> pushNamed<T extends Object>(String routeName, {Object arguments}) {
    final possibleRoute = router.getScreen(routeName: routeName);
    if (possibleRoute == null && parent != null) {
      return parent.pushNamed<T>(routeName, arguments: arguments);
    }
    return super.pushNamed<T>(routeName, arguments: arguments);
  }

  @override
  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      String routeName,
      {Object arguments,
      TO result}) {
    final possibleRoute = router.getScreen(routeName: routeName);
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
    final possibleRoute = router.getScreen(routeName: newRouteName);
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
    final possibleRoute = router.getScreen(routeName: routeName);
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
    var isPopped = false;
    if (canPop()) {
      isPopped = super.pop<T>(result);
    }
    if (!isPopped &&
        _rootNuvigator != null &&
        this != _rootNuvigator &&
        parent != null) {
      return parentPop<T>(result);
    }
    return isPopped;
  }

  bool parentPop<T extends Object>([T result]) => parent.pop<T>(result);

  bool rootPop<T extends Object>([T result]) => _rootNuvigator.pop<T>(result);

  /// R is the return value
  Future<R> navigate<R, T>(ScreenRoute<T, R> screenRoute) {
    return pushNamed<R>(screenRoute.routeName, arguments: screenRoute.params);
  }

  NuvigatorState get parent => Nuvigator.of(context);

  bool get isNested => parent != null;

  bool get isRoot => this == _rootNuvigator;

  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)?.settings;
    print(settings);
    Widget child = super.build(context);
    if (router is GlobalRouter) {
      child = GlobalRouterProvider(globalRouter: widget.router, child: child);
    }
    if (widget.wrapperFn != null) {
      child = widget.wrapperFn(
          ScreenContext(context: context, settings: settings), child);
    }
    return child;
  }
}
