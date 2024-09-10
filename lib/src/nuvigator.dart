import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'nu_router.dart';
import 'screen_type.dart';
import 'screen_types/material_screen_type.dart';
import 'typings.dart';

enum DeepLinkPushMethod {
  Push,
  PushReplacement,
  PopAndPush,
}

class NuvigatorStateTracker extends NavigatorObserver {
  final List<Route?> stack = [];

  bool get debug => nuvigator!.widget.debug;

  NuvigatorState? get nuvigator => navigator as NuvigatorState<INuRouter>?;

  List<String?> get stackRouteNames =>
      stack.map((it) => it!.settings.name).toList();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    stack.add(route);
    if (debug) print('didPush $route: $stackRouteNames');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    stack.remove(route);
    if (debug) print('didPop $route: $stackRouteNames');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    stack.remove(route);
    if (debug) print('didRemove $route: $stackRouteNames');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final index = stack.indexOf(oldRoute);
    stack[index] = newRoute;
    if (debug) print('didReplace $oldRoute to $newRoute: $stackRouteNames');
  }
}

abstract class INuRouter {
  /// When the [NuvigatorState] is initialized this method is called on the respective
  /// [INuRouter] to register it's reference.
  void install(NuvigatorState nuvigator);

  /// When the [NuvigatorState] disposes, this method is called on the respective
  /// [INuRouter] to perform any cleanup work required.
  void dispose();

  /// In case this [INuRouter] is not able to provide a [Route] for the requested
  /// deepLink, and this property is different from null, it will be called to perform
  /// a fallback execution
  HandleDeepLinkFn? onDeepLinkNotFound;

  /// When a new deepLink is requested to be opened the [Nuvigator] this method is
  /// called in the respective [INuRouter] to retrieve the [Route] to be presented
  Route<T>? getRoute<T>({
    required String deepLink,
    Object? parameters,
    bool isFromNative = false,
    ScreenType? fallbackScreenType,
    ScreenType? overrideScreenType,
  });
}

class _NuvigatorInner<T extends INuRouter> extends Navigator {
  _NuvigatorInner({
    required this.router,
    required String initialDeepLink,
    Map<String, dynamic>? initialArguments,
    Key? key,
    List<NavigatorObserver> observers = const [],
    this.screenType = materialScreenType,
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
  }) : super(
          observers: [
            HeroController(),
            ...observers,
          ],
          onGenerateInitialRoutes: (_, __) {
            final r = router.getRoute<dynamic>(
              deepLink: initialDeepLink,
              parameters: initialArguments,
              fallbackScreenType: screenType,
            );
            if (r == null) {
              throw FlutterError(
                  'No Route was found for the initialRoute provided: "$initialDeepLink"'
                  ' .Be sure that the provided initialRoute exists in this Router ($router).');
            }
            return [r];
          },
          onGenerateRoute: (settings) {
            assert(
                settings.name != null, 'RouteSettings name should not be null');
            return router.getRoute<dynamic>(
              deepLink: settings.name!,
              parameters: settings.arguments,
              fallbackScreenType: screenType,
            );
          },
          key: key,
        );

  final T router;
  final bool debug;
  final bool shouldPopRoot;
  final ScreenType screenType;
  final WrapperFn? wrapper;
  final List<ObserverBuilder> inheritableObservers;

  @override
  NavigatorState createState() {
    return NuvigatorState<T>();
  }
}

class NuvigatorState<T extends INuRouter> extends NavigatorState
    with WidgetsBindingObserver {
  NuvigatorState get rootNuvigator =>
      Nuvigator.maybeOf(context, rootNuvigator: true) ?? this;

  List<NuvigatorState> nestedNuvigators = [];

  NuvigatorStateTracker? stateTracker;

  NuvigatorState? parent;

  NuvigatorPageRoute? _presenterRoute;

  @override
  _NuvigatorInner get widget => super.widget as _NuvigatorInner<INuRouter>;

  T get router => widget.router as T;

  /// Returns the current Route stack that is rendered in this Nuvigator
  List<Route?> get stack => stateTracker!.stack;

  /// If this Nuvigator is nested, return the Route that is presenting it
  NuvigatorPageRoute? get presenterRoute => _presenterRoute;

  /// Returns true if this Nuvigator has a parent Nuvigator, and thus is considered nested
  bool get isNested => parent != null;

  /// Returns true if this Nuvigator is the Root one (top level)
  bool get isRoot => this == rootNuvigator;

  /// Returns the top most route of this Nuvigator
  Route? get currentRoute => stateTracker!.stack.last;

  INuRouter get rootRouter => rootNuvigator.router;

  List<ObserverBuilder> _collectObservers() {
    if (isNested) {
      return widget.inheritableObservers + parent!._collectObservers();
    }
    return widget.inheritableObservers;
  }

  @override
  void initState() {
    parent = Nuvigator.maybeOf(context);
    if (isNested) {
      parent!.nestedNuvigators.add(this);
    }
    widget.observers.addAll(_collectObservers().map((f) => f()));
    stateTracker = NuvigatorStateTracker();
    widget.observers.add(stateTracker!);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.router.install(this);
  }

  @override
  void didChangeDependencies() {
    if (isNested) {
      final maybePresenterRoute = NuvigatorPageRoute.of(context);
      if (maybePresenterRoute != null) {
        _presenterRoute = maybePresenterRoute;
        _presenterRoute!.nestedNuvigator = this;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_NuvigatorInner oldWidget) {
    if (oldWidget.router != widget.router) {
      widget.router.install(this);
    }

    /// Since every update the observers will be overridden by the constructor
    /// parameters, the stateTracker and inheritableObservers should be injected
    /// again.
    widget.observers.add(stateTracker!);
    widget.observers.addAll(_collectObservers().map((f) => f()));
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.router.dispose();
    stateTracker = null;
    if (isNested) {
      parent!.nestedNuvigators.remove(this);
      if (_presenterRoute != null) {
        _presenterRoute!.nestedNuvigator = null;
      }
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

  Route<R>? _getRoute<R>(String routeName, [Object? parameters]) {
    return router.getRoute<R>(
      deepLink: routeName,
      parameters: parameters,
      isFromNative: false,
      fallbackScreenType: widget.screenType,
    );
  }

  Future<dynamic> _handleDeepLinkNotFound(String deepLink,
      [Object? parameters]) async {
    return await router.onDeepLinkNotFound!(
      router,
      Uri.parse(deepLink),
      false,
      parameters,
    );
  }

  bool canOpen(String route, {Object? arguments}) =>
      _getRoute(route, arguments) != null;

  Future<R> _doForDeepLink<R>(
    String deepLink, {
    Object? parameters,
    Future<R> Function(Route<R> route)? onRouteFound,
    Future<R> Function(NuvigatorState? parent)? delegateToParent,
  }) async {
    final route = _getRoute(deepLink, parameters);
    if (route != null) {
      return await onRouteFound!(route as Route<R>);
    } else if (router.onDeepLinkNotFound != null) {
      return await _handleDeepLinkNotFound(deepLink, parameters);
    } else if (isNested) {
      return await delegateToParent!(parent);
    } else {
      throw FlutterError(
        'DeepLink `$deepLink` was not found, and no `onDeepLinkNotFound` was specified in the $router.',
      );
    }
  }

  @override
  Future<R?> pushNamed<R extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _doForDeepLink(
      routeName,
      parameters: arguments,
      onRouteFound: (route) => super.push<R?>(route),
      delegateToParent: (parent) =>
          parent!.pushNamed<R>(routeName, arguments: arguments),
    );
  }

  @override
  Future<R?> pushReplacementNamed<R extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return _doForDeepLink(
      routeName,
      parameters: arguments,
      onRouteFound: (route) => super.pushReplacement<R?, TO>(
        route,
        result: result,
      ),
      delegateToParent: (parent) => parent!.pushReplacementNamed<R, TO>(
        routeName,
        arguments: arguments,
        result: result,
      ),
    );
  }

  @override
  Future<R?> pushNamedAndRemoveUntil<R extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _doForDeepLink(
      newRouteName,
      parameters: arguments,
      onRouteFound: (route) =>
          super.pushAndRemoveUntil(route as Route<R>, predicate),
      delegateToParent: (parent) => parent!.pushNamedAndRemoveUntil(
          newRouteName, predicate,
          arguments: arguments),
    );
  }

  @override
  Future<R?> popAndPushNamed<R extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return _doForDeepLink(
      routeName,
      parameters: arguments,
      onRouteFound: (route) => popAndPush(route as Route<R>, result: result),
      delegateToParent: (parent) => parent!.popAndPushNamed(routeName),
    );
  }

  Future<R?> popAndPush<R extends Object?, TO extends Object?>(
    Route<R> newRoute, {
    TO? result,
  }) {
    pop(result);
    return push(newRoute);
  }

  void replaceNamed<R extends Object?>({
    required String oldDeepLink,
    required String newDeepLink,
    Object? arguments,
  }) {
    _doForDeepLink(
      newDeepLink,
      onRouteFound: (route) async {
        final oldRoute =
            stateTracker!.stack.firstWhere(NuRoute.withPath(oldDeepLink));
        if (oldRoute == null) {
          throw FlutterError(
            '`$oldDeepLink` was not found in the $router when calling replaceNamed with the newDeepLink as `$newDeepLink`',
          );
        }
        replace(newRoute: route, oldRoute: oldRoute);
      },
      delegateToParent: (parent) async => parent!.replaceNamed(
        oldDeepLink: oldDeepLink,
        newDeepLink: newDeepLink,
        arguments: arguments,
      ),
      parameters: arguments,
    );
  }

  /// Will try to find the first Route that matches the predicate and remove it from its Stack
  void removeByPredicate(NullableRoutePredicate predicate) {
    final route = stateTracker!.stack.firstWhere(predicate, orElse: () => null);
    if (route != null) {
      super.removeRoute(route);
    } else if (isNested) {
      parent!.removeByPredicate(predicate);
    }
  }

  @override
  void pop<R extends Object?>([R? result]) {
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

  void parentPop<R extends Object?>([R? result]) => parent!.pop<R>(result);

  void rootPop<R extends Object?>([R? result]) => rootNuvigator.pop<R>(result);

  void closeFlow<R extends Object?>([R? result]) {
    if (isNested) {
      parentPop(result);
    }
  }

  /// Prefer using [NuvigatorState.open], `.openDeepLink` does not support opening nested deepLinks
  Future<R?> openDeepLink<R>(Uri deepLink, [dynamic arguments]) {
    return rootNuvigator.open(
      deepLink.toString(),
      parameters: arguments,
    );
  }

  /// Open the requested deepLink, if the current Nuvigator is not able to handle
  /// it, and no [INuRouter.onDeepLinkNotFound] is provided, then we try to open the
  /// deepLink in the parent Nuvigator.
  /// [screenType] argument can be used to override the default screenType provided by the to be opened Route
  /// [pushMethod] allows for customizing how the new Route will be pushed into the stack
  /// [parameters] is a helper to inject arguments that would be present in the DeepLink query/path parameters
  /// [result] is optional and will be used only when the pushMethod is PopAndPush or PushReplacement
  Future<R?> open<R extends Object?>(
    String deepLink, {
    DeepLinkPushMethod pushMethod = DeepLinkPushMethod.Push,
    ScreenType? screenType,
    Map<String, dynamic>? parameters,
    bool isFromNative = false,
    Object? result,
  }) {
    final route = router.getRoute<R>(
      deepLink: deepLink,
      parameters: parameters,
      isFromNative: isFromNative,
      fallbackScreenType: widget.screenType,
      overrideScreenType: screenType,
    );
    if (route != null) {
      switch (pushMethod) {
        case DeepLinkPushMethod.Push:
          return push<R>(route);
        case DeepLinkPushMethod.PushReplacement:
          return pushReplacement<R, dynamic>(route, result: result);
        case DeepLinkPushMethod.PopAndPush:
          return popAndPush(route, result: result);
        default:
          return push<R>(route);
      }
    } else if (router.onDeepLinkNotFound != null) {
      final uriDeepLink = Uri.parse(deepLink);
      return router.onDeepLinkNotFound!(router, uriDeepLink, false, parameters)
          .then((value) => value as R?);
    } else if (isNested) {
      return parent!.open<R>(
        deepLink,
        parameters: parameters,
        pushMethod: pushMethod,
        result: result,
        screenType: screenType,
        isFromNative: isFromNative,
      );
    } else {
      throw FlutterError(
        'DeepLink $deepLink was not found, and no `onDeepLinkNotFound` was specified.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var child = super.build(context);
    if (widget.wrapper != null) {
      child = widget.wrapper!(context, child);
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

/// Creates a new Nuvigator. When using the Next API, several of those options
/// are provided by the [INuRouter]. Providing them here will thrown an assertion
/// error.
@immutable
class Nuvigator<T extends INuRouter?> extends StatelessWidget {
  const Nuvigator({
    required this.router,
    this.initialArguments,
    Key? key,
    this.observers = const [],
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
    this.shouldRebuild,
  })  : _innerKey = key,
        assert(router != null);

  /// Creates a [Nuvigator] from a list of [NuRoute]
  static Nuvigator<NuRouterBuilder> routes({
    required String initialRoute,
    required List<NuRoute> routes,
    ScreenType? screenType,
    List<ObserverBuilder> inheritableObservers = const [],
    List<NavigatorObserver> observers = const [],
    bool debug = false,
    bool shouldPopRoot = false,
    ShouldRebuildFn? shouldRebuild,
    Key? key,
  }) {
    return Nuvigator(
      key: key,
      inheritableObservers: inheritableObservers,
      debug: debug,
      observers: observers,
      shouldPopRoot: shouldPopRoot,
      shouldRebuild: shouldRebuild,
      router: NuRouterBuilder(
        routes: routes,
        initialRoute: initialRoute,
        screenType: screenType,
      ),
    );
  }

  final T router;
  final bool debug;
  final bool shouldPopRoot;
  final WrapperFn? wrapper;
  final List<ObserverBuilder> inheritableObservers;
  final List<NavigatorObserver> observers;
  final Key? _innerKey;
  final Map<String, dynamic>? initialArguments;
  final ShouldRebuildFn? shouldRebuild;

  /// Maybe fetches a [NuvigatorState] from the current BuildContext.
  static NuvigatorState<T>? maybeOf<T extends INuRouter>(
    BuildContext context, {
    bool rootNuvigator = false,
  }) {
    if (rootNuvigator) {
      return context.findRootAncestorStateOfType<NuvigatorState<T>>();
    } else {
      final closestNuvigator =
          context.findAncestorStateOfType<NuvigatorState<T>>();
      if (closestNuvigator != null) return closestNuvigator;

      return null;
    }
  }

  /// Fetches a [NuvigatorState] from the current BuildContext, or throws an
  /// error if doesn't find it
  static NuvigatorState<T> of<T extends INuRouter>(
    BuildContext context, {
    bool rootNuvigator = false,
  }) {
    final nuvigatorState =
        Nuvigator.maybeOf<T>(context, rootNuvigator: rootNuvigator);

    assert(() {
      if (nuvigatorState == null) {
        throw FlutterError(
            'Nuvigator operation requested with a context that does not include a Nuvigator.\n'
            'The context used to push or pop routes from the Nuvigator must be that of a '
            'widget that is a descendant of a Nuvigator widget.'
            'Also check if the provided Router [T] type exists withing a the Nuvigator context.');
      }

      return true;
    }());

    return nuvigatorState!;
  }

  /// Helper method that allows passing a Nuvigator to a builder function
  Nuvigator call(BuildContext context, [Widget? child]) {
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return NuRouterLoader(
      // ignore: avoid_as
      router: router as NuRouter,
      shouldRebuild: shouldRebuild,
      builder: (moduleRouter) => _NuvigatorInner(
        router: moduleRouter,
        debug: debug,
        inheritableObservers: inheritableObservers,
        observers: observers,
        initialDeepLink: moduleRouter.initialRoute,
        screenType: moduleRouter.screenType ?? materialScreenType,
        key: _innerKey,
        initialArguments: initialArguments,
        shouldPopRoot: shouldPopRoot,
      ),
    );
  }
}
