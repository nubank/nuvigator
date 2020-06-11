import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuvigator/src/helpers.dart';
import 'package:nuvigator/src/screen_types/material_screen_type.dart';

import 'nu_route_settings.dart';
import 'router.dart';
import 'screen_route.dart';
import 'screen_type.dart';

typedef ObserverBuilder = NavigatorObserver Function();
typedef InitialDeepLinkFn<T> = String Function(T router);

/// Should return `true` if the deepLink was handled and should halt execution,
/// otherwise false.
typedef DeepLinkInterceptor = bool Function(String deepLink,
    [Object arguments, bool isFromNative]);

NuvigatorState _tryToFindNuvigatorForRouter<T extends Router>(
    NuvigatorState nuvigatorState) {
  if (nuvigatorState == null) return null;
  final nuvigatorRouterForType = nuvigatorState.router.getRouter<T>();
  if (nuvigatorRouterForType != null) return nuvigatorState;
  if (nuvigatorState != nuvigatorState.parent && nuvigatorState.parent != null)
    return _tryToFindNuvigatorForRouter<T>(nuvigatorState.parent);
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

class _NuvigatorInner<T extends Router> extends Navigator {
  _NuvigatorInner({
    @required this.router,
    String initialRoute,
    Key key,
    List<NavigatorObserver> observers = const [],
    this.parentRoute,
    this.screenType = materialScreenType,
    this.deepLinkInterceptor,
    this.initialArguments,
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
  })  : assert(router != null),
        super(
          observers: [
            HeroController(),
            ...observers,
          ],
          onGenerateInitialRoutes: (state, routeName) {
            return [
              router.getRoute<dynamic>(
                  RouteSettings(name: routeName, arguments: initialArguments))
            ];
          },
          onGenerateRoute: (settings) =>
              router.getRoute<dynamic>(settings, screenType),
          key: key,
          initialRoute: initialRoute ?? parentRoute?.name,
        );

  _NuvigatorInner<T> copyWith({
    Object initialArguments,
    WrapperFn wrapper,
    Key key,
    bool debugLog,
    ScreenType screenType,
    NuRouteSettings parentRoute,
    List<ObserverBuilder> inheritableObservers,
    String initialRoute,
  }) {
    return _NuvigatorInner<T>(
      router: router,
      parentRoute: parentRoute ?? this.parentRoute,
      initialRoute: initialRoute ?? this.initialRoute,
      debug: debugLog ?? debug,
      inheritableObservers: inheritableObservers ?? this.inheritableObservers,
      screenType: screenType ?? this.screenType,
      wrapper: wrapper ?? this.wrapper,
      key: key ?? this.key,
    );
  }

  final T router;
  final NuRouteSettings parentRoute;
  final bool debug;
  final bool shouldPopRoot;
  final ScreenType screenType;
  final Map<String, dynamic> initialArguments;
  final DeepLinkInterceptor deepLinkInterceptor;
  final WrapperFn wrapper;
  final List<ObserverBuilder> inheritableObservers;

  _NuvigatorInner call(BuildContext context, [Widget child]) {
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
      _NuvigatorInner.of(context, rootNuvigator: true) ?? this;

  @override
  _NuvigatorInner get widget => super.widget;

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
    parent = _NuvigatorInner.of(context, nullOk: true);
    if (isNested) {
      parent.nestedNuvigators.add(this);
    }
    widget.observers.addAll(_collectObservers().map((f) => f()));
    stateTracker = NuvigatorStateTracker();
    widget.observers.add(stateTracker);
    WidgetsBinding.instance.addObserver(this);
    widget.router.install(this);
    super.initState();
  }

  @override
  void didUpdateWidget(_NuvigatorInner oldWidget) {
    if (oldWidget.router != widget.router) {
      widget.router.install(this);
      widget.observers.add(stateTracker);
      widget.observers.addAll(_collectObservers().map((f) => f()));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.router.uninstall();
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
  void pop<T extends Object>([T result]) {
    var isPoppable = canPop();
    if (isPoppable) {
      super.pop<T>(result);
    } else if (widget.shouldPopRoot && this == rootNuvigator) {
      isPoppable = true;
      SystemNavigator.pop();
    }
    if (!isPoppable && this != rootNuvigator && parent != null) {
      parentPop<T>(result);
    }
  }

  void parentPop<T extends Object>([T result]) => parent.pop<T>(result);

  void rootPop<T extends Object>([T result]) => rootNuvigator.pop<T>(result);

  void closeFlow<T extends Object>([T result]) {
    if (isNested) {
      parentPop(result);
    }
  }

  Future<R> openDeepLink<R extends Object>(String deepLink,
      [dynamic arguments, bool isFromNative = false]) async {
    if (widget.deepLinkInterceptor != null) {
      final handled =
          widget.deepLinkInterceptor(deepLink, arguments, isFromNative);
      if (handled) return Future.value(null);
    }

    final route = router.getRoute<T>(RouteSettings(name: deepLink));

    if (route == null) {
      if (isRoot && router.onDeepLinkNotFound != null) {}
      if (isRoot) {
        if (router.onDeepLinkNotFound != null) {
          return await router.onDeepLinkNotFound(
              router, deepLink, isFromNative, arguments);
        } else {
          throw FlutterError('No Route was found for $deepLink, and no '
              'onDeepLinkNotFound function was provided by the Root Router $router.');
        }
      } else {
        return parent.openDeepLink<R>(deepLink, arguments, isFromNative);
      }
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

@immutable
class Nuvigator<T extends Router> extends StatelessWidget {
  const Nuvigator({
    @required this.router,
    this.initialRoute,
    Key key,
    this.observers = const [],
    this.screenType = materialScreenType,
    this.wrapper,
    this.initialArguments,
    this.debug = false,
    this.inheritableObservers = const [],
    this.deepLinkInterceptor,
    this.includePrefix = true,
    this.shouldPopRoot = false,
  }) : innerKey = key;

  final String initialRoute;
  final List<NavigatorObserver> observers;
  final T router;
  final Key innerKey;
  final bool includePrefix;
  final bool debug;
  final Map<String, Object> initialArguments;
  final bool shouldPopRoot;
  final ScreenType screenType;
  final DeepLinkInterceptor deepLinkInterceptor;
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

  String get prefixedInitialRoute =>
      includePrefix ? (router.deepLinkPrefix + initialRoute) : initialRoute;

  @override
  Widget build(BuildContext context) {
    final routeSettings = NuRouteSettingsProvider.of(context);
    final parentRoute = routeSettings?.routePath?.path ?? '';
    final nestedInitialRoute = routeSettings != null
        ? trimPrefix(routeSettings.name, parentRoute)
        : null;

    final ir = initialRoute != null ? prefixedInitialRoute : nestedInitialRoute;

    return _NuvigatorInner(
      router: router,
      debug: debug,
      inheritableObservers: inheritableObservers,
      observers: observers,
      deepLinkInterceptor: deepLinkInterceptor,
      initialArguments: initialArguments,
      initialRoute: ir,
      key: key,
      parentRoute: routeSettings,
      screenType: screenType,
      shouldPopRoot: shouldPopRoot,
      wrapper: wrapper,
    );
  }
}
