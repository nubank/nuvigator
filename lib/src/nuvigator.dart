import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuvigator/nuvigator.dart';

import 'router.dart';

typedef ObserverBuilder = NavigatorObserver Function();

NuvigatorState _tryToFindNuvigatorForRouter<T extends Router>(
    NuvigatorState nuvigatorState) {
  if (nuvigatorState == null) return null;
  final nuvigatorRouterForType = nuvigatorState.router.getRouter<T>();
  if (nuvigatorRouterForType != null) return nuvigatorState;
  if (nuvigatorState != nuvigatorState.parent && nuvigatorState.parent != null)
    return _tryToFindNuvigatorForRouter<T>(nuvigatorState.parent);
  return null;
}

String currentDeepLink(BuildContext context) {
  return ModalRoute.of(context).settings.name;
}

class NuvigatorStateTracker extends NavigatorObserver {
  final List<Route> stack = [];

  bool get debug => nuvigator.widget.debug;

  NuvigatorState get nuvigator => navigator;

  List<String> get stackRouteNames =>
      stack.map((it) => it.settings.name).toList();

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    stack.add(route);
    if (debug) print('didPush $route: $stackRouteNames');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    stack.remove(route);
    if (debug) print('didPop $route: $stackRouteNames');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    stack.remove(route);
    if (debug) print('didRemove $route: $stackRouteNames');
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    final index = stack.indexOf(oldRoute);
    stack[index] = newRoute;
    if (debug) print('didReplace $oldRoute to $newRoute: $stackRouteNames');
  }
}

class Nuvigator<T extends Router> extends Navigator {
  Nuvigator({
    @required this.router,
    @required this.initialDeepLink,
    Key key,
    List<NavigatorObserver> observers = const [],
    this.screenType = materialScreenType,
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
  })  : assert(router != null),
        assert(initialDeepLink != null),
        super(
          observers: [
            HeroController(),
            ...observers,
          ],
          onGenerateRoute: (settings) =>
              router.getRoute<dynamic>(settings, screenType),
          key: key,
          initialRoute: initialDeepLink,
        );

  Nuvigator<T> copyWith({
    Object initialArguments,
    WrapperFn wrapper,
    Key key,
    bool debugLog,
    ScreenType screenType,
    List<ObserverBuilder> inheritableObservers,
    String initialDeepLink,
  }) {
    return Nuvigator<T>(
      router: router,
      initialDeepLink: initialDeepLink ?? this.initialDeepLink,
      debug: debugLog ?? debug,
      inheritableObservers: inheritableObservers ?? this.inheritableObservers,
      screenType: screenType ?? this.screenType,
      wrapper: wrapper ?? this.wrapper,
      key: key ?? this.key,
    );
  }

  final T router;
  final String initialDeepLink;
  final bool debug;
  final bool shouldPopRoot;
  final ScreenType screenType;
  final WrapperFn wrapper;
  final List<ObserverBuilder> inheritableObservers;

  Nuvigator call(BuildContext context, [Widget child]) {
    return this;
  }

  static NuvigatorState ofRouter<T extends Router>(BuildContext context) {
    final NuvigatorState closestNuvigator =
        context.findAncestorStateOfType<NuvigatorState>();
    return _tryToFindNuvigatorForRouter<T>(closestNuvigator);
  }

  static NuvigatorState<T> of<T extends Router>(
    BuildContext context, {
    bool rootNuvigator = false,
    bool nullOk = false,
  }) {
    if (rootNuvigator)
      return context.findRootAncestorStateOfType<NuvigatorState<T>>();
    final nuvigatorState = ofRouter<T>(context);
    if (nuvigatorState is NuvigatorState<T>) return nuvigatorState;
    assert(() {
      if (!nullOk) {
        throw FlutterError(
            'Nuvigator operation requested with a context that does not include a Nuvigator.\n'
            'The context used to push or pop routes from the Nuvigator must be that of a '
            'widget that is a descendant of a Nuvigator widget.'
            'Also check if the provided Router [T] type exists withing a the Nuvigator context.');
      }
      return true;
    }());
    return null;
  }

  @override
  NavigatorState createState() {
    return NuvigatorState<T>();
  }
}

class NuvigatorState<T extends Router> extends NavigatorState
    with WidgetsBindingObserver {
  NuvigatorState get rootNuvigator =>
      Nuvigator.of(context, rootNuvigator: true) ?? this;

  @override
  Nuvigator get widget => super.widget;

  List<NuvigatorState> nestedNuvigators = [];

  T get router => widget.router;

  NuvigatorStateTracker stateTracker;

  R getRouter<R extends Router>() => router.getRouter<R>();

  List<ObserverBuilder> _collectObservers() {
    if (isNested) {
      return widget.inheritableObservers + parent._collectObservers();
    }
    return widget.inheritableObservers;
  }

  @override
  void initState() {
    parent = Nuvigator.of(context, nullOk: true);
    if (isNested) {
      parent.nestedNuvigators.add(this);
    }
    widget.observers.addAll(_collectObservers().map((f) => f()));
    stateTracker = NuvigatorStateTracker();
    widget.observers.add(stateTracker);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    assert(widget.router.nuvigator == null);
    widget.router.nuvigator = this;
  }

  @override
  void didUpdateWidget(Nuvigator oldWidget) {
    if (oldWidget.router != widget.router) {
      oldWidget.router.nuvigator = null;
      assert(widget.router.nuvigator == null);
      widget.router.nuvigator = this;
      widget.observers.add(stateTracker);
      widget.observers.addAll(_collectObservers().map((f) => f()));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.router.nuvigator = null;
    stateTracker = null;
    if (isNested) {
      parent.nestedNuvigators.remove(this);
    }
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
    final possibleRoute = router
        .getRoute<T>(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null && parent != null) {
      return parent.pushNamed<T>(routeName, arguments: arguments);
    }
    return super.push<T>(possibleRoute);
  }

  @override
  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      String routeName,
      {Object arguments,
      TO result}) {
    final possibleRoute = router
        .getRoute<T>(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushReplacementNamed<T, TO>(routeName,
          arguments: arguments, result: result);
    }
    return super.pushReplacement<T, TO>(possibleRoute, result: result);
  }

  @override
  Future<T> pushNamedAndRemoveUntil<T extends Object>(
      String newRouteName, RoutePredicate predicate,
      {Object arguments}) {
    final possibleRoute = router
        .getRoute<T>(RouteSettings(name: newRouteName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushNamedAndRemoveUntil<T>(newRouteName, predicate,
          arguments: arguments);
    }
    return super.pushAndRemoveUntil<T>(possibleRoute, predicate);
  }

  @override
  Future<T> popAndPushNamed<T extends Object, TO extends Object>(
      String routeName,
      {Object arguments,
      TO result}) {
    final possibleRoute = router
        .getRoute<T>(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.popAndPushNamed<T, TO>(routeName,
          arguments: arguments, result: result);
    }
    pop<TO>(result);
    return push<T>(possibleRoute);
  }

  @override
  bool pop<T extends Object>([T result]) {
    var isPopped = false;
    if (canPop()) {
      isPopped = super.pop<T>(result);
    } else if (widget.shouldPopRoot && this == rootNuvigator) {
      isPopped = true;
      SystemNavigator.pop();
    }
    if (!isPopped && this != rootNuvigator && parent != null) {
      return parentPop<T>(result);
    }
    return isPopped;
  }

  bool parentPop<T extends Object>([T result]) => parent.pop<T>(result);

  bool rootPop<T extends Object>([T result]) => rootNuvigator.pop<T>(result);

  void closeFlow<T extends Object>([T result]) {
    if (isNested) {
      parentPop(result);
    }
  }

  Future<R> openDeepLink<R extends Object>(String deepLink,
      [dynamic arguments, bool isFromNative = false]) async {
    final route = router.getRoute<T>(RouteSettings(name: deepLink));
    if (route == null) {
      if (isRoot && router.onDeepLinkNotFound != null)
        return await router.onDeepLinkNotFound(
            router, deepLink, isFromNative, arguments);
      return parent.openDeepLink<R>(deepLink, arguments, isFromNative);
    }
    if (isFromNative) {
      final route = _buildNativeRoute(deepLink, arguments);
      return push<R>(route);
    }
    return push<R>(route);
  }

  // When building a native route we assume we already the first route in the stack
  // that corresponds to the backdrop/invisible component. This allows for the
  // route animation being handled by the Flutter instead of the Native App.
  Route _buildNativeRoute(String deepLink, Map<String, String> arguments) {
    final routeSettings = RouteSettings(
      name: deepLink,
      isInitialRoute: false,
      arguments: arguments,
    );
    final route = router.getRoute<T>(routeSettings);
    route.popped.then<dynamic>((dynamic _) async {
      if (stateTracker.stack.length == 1) {
        // We only have the backdrop route in the stack
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await SystemNavigator.pop();
      }
    });
    return route;
  }

  NuvigatorState parent;

  bool get isNested => parent != null;

  bool get isRoot => this == rootNuvigator;

  Router get rootRouter => rootNuvigator.router;

  @override
  Widget build(BuildContext context) {
    Widget child = super.build(context);
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
