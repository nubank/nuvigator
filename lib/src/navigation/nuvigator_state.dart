import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuvigator/next.dart';
import 'package:nuvigator/src/navigation/deep_link_push_method.dart';
import 'package:nuvigator/src/navigation/inu_router.dart';
import 'package:nuvigator/src/navigation/nuvigator.dart';
import 'package:nuvigator/src/navigation/nuvigator_inner.dart';
import 'package:nuvigator/src/navigation/nuvigator_state_tracker.dart';

class NuvigatorState<T extends INuRouter> extends NavigatorState
    with WidgetsBindingObserver {
  NuvigatorState get rootNuvigator =>
      Nuvigator.of(context, rootNuvigator: true) ?? this;

  List<NuvigatorState> nestedNuvigators = [];

  NuvigatorStateTracker? stateTracker;

  NuvigatorState? parent;

  NuvigatorPageRoute? _presenterRoute;

  @override
  NuvigatorInner get widget => super.widget as NuvigatorInner<INuRouter>;

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
    parent = Nuvigator.of(context, nullOk: true);
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
  void didUpdateWidget(NuvigatorInner oldWidget) {
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
      super.pop<R>();
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