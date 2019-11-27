import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import 'router.dart';

typedef ObserverBuilder = NavigatorObserver Function();

class Nuvigator<T extends Router> extends Navigator {
  Nuvigator({
    @required this.router,
    String initialRoute = '/',
    Key key,
    List<NavigatorObserver> observers = const [],
    this.screenType = materialScreenType,
    this.wrapper,
    this.initialArguments,
    this.inheritableObservers = const [],
  })  : assert(router != null),
        super(
          observers: [
            HeroController(),
            ...observers,
            ...inheritableObservers.map((f) => f()),
          ],
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
                .getScreen(finalSettings)
                ?.fallbackScreenType(screenType)
                ?.toRoute(finalSettings);
          },
          key: (router is GlobalRouter) ? router.nuvigatorKey : key,
          initialRoute: initialRoute,
        );

  Nuvigator builder(BuildContext context) {
    final settings = ModalRoute.of(context)?.settings;
    final parentNuvigator = Nuvigator.of(context);
    return copyWith(
      initialArguments: settings?.arguments,
      inheritableObservers: [
        ...parentNuvigator?.widget?.inheritableObservers ?? [],
        ...inheritableObservers,
      ],
    );
  }

  Nuvigator<T> copyWith({
    Object initialArguments,
    WrapperFn wrapper,
    Key key,
    ScreenType screenType,
    List<ObserverBuilder> inheritableObservers,
    String initialRoute,
  }) {
    return Nuvigator<T>(
      initialRoute: initialRoute ?? this.initialRoute,
      router: router,
      inheritableObservers: inheritableObservers,
      screenType: screenType ?? this.screenType,
      wrapper: wrapper ?? this.wrapper,
      initialArguments: initialArguments ?? this.initialArguments,
      key: key ?? this.key,
    );
  }

  final T router;
  final Object initialArguments;
  final ScreenType screenType;
  final WrapperFn wrapper;
  final List<ObserverBuilder> inheritableObservers;

  Nuvigator call(BuildContext context, [Widget child]) {
    return builder(context);
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

class NuvigatorState<T extends Router> extends NavigatorState with WidgetsBindingObserver {
  NuvigatorState<GlobalRouter> get _rootNuvigator =>
      Nuvigator.of<GlobalRouter>(context, rootNuvigator: true) ?? this;

  @override
  Nuvigator get widget => super.widget;

  T get router => widget.router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // On Android: the user has pressed the back button.
  @override
  Future<bool> didPopRoute() async {
    assert(mounted);
    return await maybePop();
  }

  @override
  Future<bool> didPushRoute(String route) async {
    assert(mounted);
    pushNamed(route);
    return true;
  }

  @override
  Future<T> pushNamed<T extends Object>(String routeName, {Object arguments}) {
    final possibleRoute =
        router.getScreen(RouteSettings(name: routeName, arguments: arguments));
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
    final possibleRoute =
        router.getScreen(RouteSettings(name: routeName, arguments: arguments));
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
    final possibleRoute = router
        .getScreen(RouteSettings(name: newRouteName, arguments: arguments));
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
    final possibleRoute =
        router.getScreen(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.popAndPushNamed<T, TO>(routeName,
          arguments: arguments, result: result);
    }
    return super.popAndPushNamed<T, TO>(routeName,
        arguments: arguments, result: result);
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
    if (widget.wrapper != null) {
      child = widget.wrapper(context, child);
    }
    if (isNested) {
      child = WillPopScope(
        onWillPop: () async {
          return !(await maybePop());
        },
        child: child,
      );
    }
    return child;
  }
}
