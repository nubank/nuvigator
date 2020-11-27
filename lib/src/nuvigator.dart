import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuvigator/nuvigator.dart';

import 'next/v1/nu_module.dart';
import 'nurouter.dart';

typedef ObserverBuilder = NavigatorObserver Function();

NuvigatorState _tryToFindNuvigatorForRouter<T extends NuRouter>(
    NuvigatorState nuvigatorState) {
  if (nuvigatorState == null) return null;
  final nuvigatorRouterForType = nuvigatorState.router.getRouter<T>();
  if (nuvigatorRouterForType != null) return nuvigatorState;
  if (nuvigatorState != nuvigatorState.parent &&
      nuvigatorState.parent != null) {
    return _tryToFindNuvigatorForRouter<T>(nuvigatorState.parent);
  }
  return null;
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

class _NuvigatorInner<T extends NuRouter> extends Navigator {
  _NuvigatorInner({
    @required this.router,
    String initialRoute,
    String initialDeepLink,
    Map<String, Object> initialArguments,
    Key key,
    List<NavigatorObserver> observers = const [],
    this.screenType = materialScreenType,
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
  })  : assert(router != null),
        assert(initialRoute != null || initialDeepLink != null),
        assert((initialRoute != null && initialDeepLink == null) ||
            (initialDeepLink != null && initialRoute == null)),
        assert(() {
          if (initialDeepLink != null) {
            return initialArguments == null;
          }
          return true;
        }()),
        super(
          observers: [
            HeroController(),
            ...observers,
          ],
          onGenerateInitialRoutes: (_, __) {
            // Using route name is deprecated
            if (initialRoute != null) {
              final settings = RouteSettings(
                name: initialRoute,
                arguments: initialArguments,
              );
              return [
                router
                    .getScreen(settings)
                    ?.fallbackScreenType(screenType)
                    ?.toRoute(settings),
              ];
            } else if (initialDeepLink != null) {
              return [
                router.getRoute<dynamic>(
                  initialDeepLink,
                  parameters: initialArguments,
                  fallbackScreenType: screenType,
                ),
              ];
            }
            return [];
          },
          onGenerateRoute: (settings) {
            return router
                .getScreen(settings)
                ?.fallbackScreenType(screenType)
                ?.toRoute(settings);
          },
          key: key,
        );

  final T router;
  final bool debug;
  final bool shouldPopRoot;
  final ScreenType screenType;
  final WrapperFn wrapper;
  final List<ObserverBuilder> inheritableObservers;

  @override
  NavigatorState createState() {
    return NuvigatorState<T>();
  }
}

class NuvigatorState<T extends NuRouter> extends NavigatorState
    with WidgetsBindingObserver {
  NuvigatorState get rootNuvigator =>
      Nuvigator.of(context, rootNuvigator: true) ?? this;

  @override
  _NuvigatorInner get widget => super.widget;

  List<NuvigatorState> nestedNuvigators = [];

  T get router => widget.router;

  NuvigatorStateTracker stateTracker;

  R getRouter<R extends NuRouter>() => router.getRouter<R>();

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
  void didUpdateWidget(_NuvigatorInner oldWidget) {
    if (oldWidget.router != widget.router) {
      assert(widget.router.nuvigator == null);
      widget.router.nuvigator = this;
    }

    /// Since every update the observers will be overridden by the constructor
    /// parameters, the stateTracker and inheritableObservers should be injected
    /// again.
    widget.observers.add(stateTracker);
    widget.observers.addAll(_collectObservers().map((f) => f()));
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
    // ignore: unawaited_futures
    pushNamed(route);
    return true;
  }

  @override
  Future<R> pushNamed<R extends Object>(String routeName, {Object arguments}) {
    final possibleRoute =
        router.getScreen(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null && parent != null) {
      return parent.pushNamed<R>(routeName, arguments: arguments);
    }
    return super.pushNamed<R>(routeName, arguments: arguments);
  }

  @override
  Future<R> pushReplacementNamed<R extends Object, TO extends Object>(
      String routeName,
      {Object arguments,
      TO result}) {
    final possibleRoute =
        router.getScreen(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushReplacementNamed<R, TO>(routeName,
          arguments: arguments, result: result);
    }
    return super.pushReplacementNamed<R, TO>(routeName,
        arguments: arguments, result: result);
  }

  @override
  Future<R> pushNamedAndRemoveUntil<R extends Object>(
      String newRouteName, RoutePredicate predicate,
      {Object arguments}) {
    final possibleRoute = router
        .getScreen(RouteSettings(name: newRouteName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.pushNamedAndRemoveUntil<R>(newRouteName, predicate,
          arguments: arguments);
    }
    return super.pushNamedAndRemoveUntil<R>(newRouteName, predicate,
        arguments: arguments);
  }

  @override
  Future<R> popAndPushNamed<R extends Object, TO extends Object>(
      String routeName,
      {Object arguments,
      TO result}) {
    final possibleRoute =
        router.getScreen(RouteSettings(name: routeName, arguments: arguments));
    if (possibleRoute == null) {
      return parent.popAndPushNamed<R, TO>(routeName,
          arguments: arguments, result: result);
    }
    return super.popAndPushNamed<R, TO>(routeName,
        arguments: arguments, result: result);
  }

  @override
  void pop<R extends Object>([R result]) {
    var isPopped = false;
    if (canPop()) {
      isPopped = super.canPop();
      super.pop<R>(result);
    } else if (widget.shouldPopRoot && this == rootNuvigator) {
      isPopped = true;
      SystemNavigator.pop();
    }
    if (!isPopped && this != rootNuvigator && parent != null) {
      parentPop<R>(result);
    }
  }

  void parentPop<R extends Object>([R result]) => parent.pop<R>(result);

  void rootPop<R extends Object>([R result]) => rootNuvigator.pop<R>(result);

  void closeFlow<R extends Object>([R result]) {
    if (isNested) {
      parentPop(result);
    }
  }

  /// Prefer using [NuvigatorState.open]
  @deprecated
  Future<R> openDeepLink<R>(Uri deepLink, [dynamic arguments]) {
    return rootRouter.openDeepLink<R>(deepLink, arguments, false);
  }

  /// Open the requested deepLink, if the current Nuvigator is not able to handle
  /// it, and not [NuRouter.onDeepLinkNotFound] is provided, then we try to open the
  /// deepLink in the parent Nuvigator.
  Future<R> open<R>(String deepLink, {Map<String, dynamic> parameters}) {
    final route = router.getRoute<R>(
      deepLink,
      parameters: parameters,
      fallbackScreenType: widget.screenType,
    );
    if (route != null) {
      return push(route);
    } else if (router.onDeepLinkNotFound != null) {
      return router.onDeepLinkNotFound(
          router, Uri.parse(deepLink), false, parameters);
    } else if (isNested) {
      return parent.open(deepLink, parameters: parameters);
    } else {
      throw FlutterError(
          'DeepLink $deepLink was not found, and no `onDeepLinkNotFound` was specified.');
    }
  }

  NuvigatorState parent;

  bool get isNested => parent != null;

  bool get isRoot => this == rootNuvigator;

  NuRouter get rootRouter => rootNuvigator.router;

  @override
  Widget build(BuildContext context) {
    var child = super.build(context);
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

@immutable
class Nuvigator<T extends NuRouter> extends StatelessWidget {
  const Nuvigator({
    this.router,
    this.initialRoute,
    this.initialDeepLink,
    this.module,
    this.initialArguments,
    this.key,
    this.observers = const [],
    this.screenType = materialScreenType,
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
  }) : assert((module != null) != (router != null));

  factory Nuvigator.module({NuModule module}) {
    return Nuvigator(
      module: module,
    );
  }

  final T router;
  final NuModule module;
  final bool debug;
  final bool shouldPopRoot;
  final ScreenType screenType;
  final WrapperFn wrapper;
  final List<ObserverBuilder> inheritableObservers;
  final List<NavigatorObserver> observers;
  @override
  // ignore: overridden_fields
  final Key key;
  final String initialRoute;
  final String initialDeepLink;
  final Map<String, Object> initialArguments;

  static NuvigatorState ofRouter<T extends NuRouter>(BuildContext context) {
    final closestNuvigator = context.findAncestorStateOfType<NuvigatorState>();
    return _tryToFindNuvigatorForRouter<T>(closestNuvigator);
  }

  static NuvigatorState<T> of<T extends NuRouter>(
    BuildContext context, {
    bool rootNuvigator = false,
    bool nullOk = false,
  }) {
    if (rootNuvigator) {
      return context.findRootAncestorStateOfType<NuvigatorState<T>>();
    }
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

  Nuvigator<T> copyWith({
    Object initialArguments,
    WrapperFn wrapper,
    Key key,
    bool debugLog,
    ScreenType screenType,
    List<ObserverBuilder> inheritableObservers,
    String initialRoute,
  }) {
    return Nuvigator<T>(
      initialRoute: initialRoute ?? this.initialRoute,
      router: router,
      debug: debugLog ?? debug,
      inheritableObservers: inheritableObservers ?? this.inheritableObservers,
      screenType: screenType ?? this.screenType,
      wrapper: wrapper ?? this.wrapper,
      key: key ?? this.key,
    );
  }

  Nuvigator call(BuildContext context, [Widget child]) {
    return this;
  }

  Widget _buildModule(BuildContext context) {
    return NuModuleLoader(
      module: module,
      builder: (moduleRouter) => _NuvigatorInner(
        router: moduleRouter,
        debug: debug,
        inheritableObservers: inheritableObservers,
        observers: observers,
        initialDeepLink: moduleRouter.module.initialRoute ?? initialDeepLink,
        screenType: module.screenType ?? screenType,
        key: key,
        initialArguments: initialArguments,
        wrapper: module.routeWrapper ?? wrapper,
        shouldPopRoot: shouldPopRoot,
      ),
    );
  }

  Widget _buildRouter(BuildContext context) {
    return _NuvigatorInner<T>(
      router: router,
      debug: debug,
      inheritableObservers: inheritableObservers,
      observers: observers,
      initialDeepLink: initialDeepLink,
      initialRoute: initialRoute,
      screenType: screenType,
      key: key,
      wrapper: wrapper,
      shouldPopRoot: shouldPopRoot,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (module != null) {
      return _buildModule(context);
    } else {
      return _buildRouter(context);
    }
  }
}
