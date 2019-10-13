import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import 'router.dart';

class Nuvigator<T extends Router> extends Navigator {
  Nuvigator({
    @required this.router,
    String initialRoute = '/',
    Key key,
    List<NavigatorObserver> observers = const [],
    this.screenType = materialScreenType,
    this.wrapperFn,
    this.initialArguments,
  })  : assert(router != null),
        super(
          observers: [HeroController(), ...observers],
          onGenerateRoute: (settings) {
            var finalSettings = settings;
            if (settings.isInitialRoute &&
                settings.name == initialRoute &&
                settings.arguments == null &&
                initialArguments != null) {
              finalSettings = settings.copyWith(
                arguments: initialArguments,
              );
            }
            return router
                .getScreen(routeName: finalSettings.name)
                ?.fallbackScreenType(screenType)
                ?.toRoute(finalSettings);
          },
          key: (router is GlobalRouter) ? router.nuvigatorKey : key,
          initialRoute: initialRoute,
        );

  Nuvigator _screenBuilder(BuildContext context) {
    final settings = ModalRoute.of(context)?.settings;
    return _withInitialArguments(settings?.arguments);
  }

  Nuvigator _withInitialArguments(Object initialArguments) {
    return Nuvigator<T>(
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

  Nuvigator call(BuildContext context, [Widget child]) {
    return _screenBuilder(context);
  }

  static NuvigatorState<T> of<T extends Router>(BuildContext context,
      {bool rootNuvigator = false}) {
    return rootNuvigator
        ? context.rootAncestorStateOfType(TypeMatcher<NuvigatorState<T>>())
        : context.ancestorStateOfType(TypeMatcher<NuvigatorState<T>>());
  }

  @override
  NavigatorState createState() {
    return NuvigatorState<T>();
  }
}

class NuvigatorState<T extends Router> extends NavigatorState {
  NuvigatorState<GlobalRouter> get _rootNuvigator =>
      Nuvigator.of<GlobalRouter>(context, rootNuvigator: true) ?? this;

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
    if (!isPopped && this != _rootNuvigator && parent != null) {
      return parentPop<T>(result);
    }
    return isPopped;
  }

  bool parentPop<T extends Object>([T result]) => parent.pop<T>(result);

  bool rootPop<T extends Object>([T result]) => _rootNuvigator.pop<T>(result);

  void closeFlow<T extends Object>([T result]) {
    if (isNested) {
      parentPop(result);
    }
  }

  Future<R> openDeepLink<R>(Uri deepLink, [dynamic arguments]) {
    return globalRouter.openDeepLink<R>(deepLink, arguments, false);
  }

  NuvigatorState get parent => Nuvigator.of(context);

  bool get isNested => parent != null;

  bool get isRoot => this == _rootNuvigator;

  GlobalRouter get globalRouter => _rootNuvigator.router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final existingGlobalRouter = GlobalRouter.of(context);
    if (router is GlobalRouter && existingGlobalRouter != null) {
      throw Exception('There is already a GlobalRouter in the widget tree!');
    } else if (!(router is GlobalRouter) && isRoot) {
      throw Exception('The root Nuvigator should have a GlobalRouter!');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = super.build(context);
    if (router is GlobalRouter) {
      child = GlobalRouterProvider(globalRouter: widget.router, child: child);
    }
    if (widget.wrapperFn != null) {
      child = widget.wrapperFn(context, child);
    }
    return child;
  }
}
