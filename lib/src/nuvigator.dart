import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'legacy_nurouter.dart' as legacy;
import 'next/v1/nu_router.dart';
import 'screen_type.dart';
import 'screen_types/material_screen_type.dart';
import 'typings.dart';

enum DeepLinkPushMethod {
  Push,
  PushReplacement,
  PopAndPush,
}

NuvigatorState? _tryToFindNuvigatorForRouter<T extends INuRouter>(
    NuvigatorState? nuvigatorState) {
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

  bool get debug => nuvigator!.widget.debug;

  NuvigatorState? get nuvigator => navigator as NuvigatorState<INuRouter>?;

  List<String?> get stackRouteNames =>
      stack.map((it) => it.settings.name).toList();

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
    if (newRoute == null || oldRoute == null) return;
    final index = stack.indexOf(oldRoute);
    stack[index] = newRoute;
    if (debug) print('didReplace $oldRoute to $newRoute: $stackRouteNames');
  }
}

abstract class INuRouter {
  void install(NuvigatorState nuvigator);

  void dispose();

  HandleDeepLinkFn? onDeepLinkNotFound;

  @deprecated
  T? getRouter<T extends INuRouter>();

  Route<T>? getRoute<T>({
    required String deepLink,
    Object? parameters,
    bool fromLegacyRouteName = false,
    bool isFromNative = false,
    ScreenType? fallbackScreenType,
    ScreenType? overrideScreenType,
  });
}

class _NuvigatorInner<T extends INuRouter> extends Navigator {
  _NuvigatorInner({
    required this.router,
    String? initialRoute,
    String? initialDeepLink,
    Map<String, Object>? initialArguments,
    Key? key,
    List<NavigatorObserver> observers = const [],
    this.screenType = materialScreenType,
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
  })  : assert((initialRoute == null) != (initialDeepLink == null)),
        super(
          observers: [
            HeroController(),
            ...observers,
          ],
          onGenerateInitialRoutes: (_, __) {
            final deepLink = (initialDeepLink ?? initialRoute)!;
            final r = router.getRoute<dynamic>(
              deepLink: deepLink,
              parameters: initialArguments,
              fromLegacyRouteName: initialDeepLink == null,
              fallbackScreenType: screenType,
            );
            if (r == null) {
              throw FlutterError(
                  'No Route was found for the initialRoute provided: "$deepLink"'
                  ' .Be sure that the provided initialRoute exists in this Router ($router).');
            }
            return [r];
          },
          onGenerateRoute: (settings) {
            return router.getRoute<dynamic>(
              deepLink: settings.name!,
              parameters: settings.arguments,
              fromLegacyRouteName: true,
              fallbackScreenType: screenType,
            );
          },
          key: key,
        );

  final T router;
  final bool debug;
  final bool shouldPopRoot;
  final ScreenType? screenType;
  final WrapperFn? wrapper;
  final List<ObserverBuilder> inheritableObservers;

  @override
  NavigatorState createState() {
    return NuvigatorState<T>();
  }
}

class NuvigatorState<T extends INuRouter> extends NavigatorState
    with WidgetsBindingObserver {
  NuvigatorState get rootNuvigator {
    try {
      return Nuvigator.of(context, rootNuvigator: true);
    } catch (_) {
      return this;
    }
  }

  @override
  _NuvigatorInner get widget => super.widget as _NuvigatorInner<INuRouter>;

  List<NuvigatorState> nestedNuvigators = [];

  T get router => widget.router as T;

  NuvigatorStateTracker? stateTracker;

  R? getRouter<R extends INuRouter>() => router.getRouter<R>();

  List<ObserverBuilder> _collectObservers() {
    if (isNested) {
      return widget.inheritableObservers + parent!._collectObservers();
    }
    return widget.inheritableObservers;
  }

  @override
  void initState() {
    parent = Nuvigator._of(context);
    if (isNested) {
      parent!.nestedNuvigators.add(this);
    }
    widget.observers.addAll(_collectObservers().map((f) => f()));
    stateTracker = NuvigatorStateTracker();
    widget.observers.add(stateTracker!);
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    widget.router.install(this);
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
    }
    WidgetsBinding.instance!.removeObserver(this);
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

  bool canOpen(String route, {Object? arguments}) {
    return router.getRoute<dynamic>(
          deepLink: route,
          parameters: arguments,
          fromLegacyRouteName: true,
          fallbackScreenType: widget.screenType,
        ) !=
        null;
  }

  @override
  Future<R?> pushNamed<R extends Object?>(String routeName,
      {Object? arguments}) {
    if (!canOpen(routeName, arguments: arguments) && isNested) {
      return parent!.pushNamed<R>(routeName, arguments: arguments);
    }
    return super.pushNamed<R>(routeName, arguments: arguments);
  }

  @override
  Future<R?> pushReplacementNamed<R extends Object?, TO extends Object?>(
      String routeName,
      {Object? arguments,
      TO? result}) {
    if (!canOpen(routeName, arguments: arguments) && isNested) {
      return parent!.pushReplacementNamed<R, TO>(routeName,
          arguments: arguments, result: result);
    }
    return super.pushReplacementNamed<R, TO>(routeName,
        arguments: arguments, result: result);
  }

  @override
  Future<R?> pushNamedAndRemoveUntil<R extends Object?>(
      String newRouteName, RoutePredicate predicate,
      {Object? arguments}) {
    if (!canOpen(newRouteName, arguments: arguments) && isNested) {
      return parent!.pushNamedAndRemoveUntil<R>(newRouteName, predicate,
          arguments: arguments);
    }
    return super.pushNamedAndRemoveUntil<R>(newRouteName, predicate,
        arguments: arguments);
  }

  @override
  Future<R?> popAndPushNamed<R extends Object?, TO extends Object?>(
      String routeName,
      {Object? arguments,
      TO? result}) {
    if (!canOpen(routeName, arguments: arguments) && isNested) {
      return parent!.popAndPushNamed<R, TO>(routeName,
          arguments: arguments, result: result);
    }
    return super.popAndPushNamed<R, TO>(routeName,
        arguments: arguments, result: result);
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
    if (rootRouter is legacy.NuRouter) {
      // ignore: avoid_as
      return (rootRouter as legacy.NuRouter)
          .openDeepLink<R>(deepLink, arguments, false);
    } else {
      return rootNuvigator.open(deepLink.toString(), parameters: arguments);
    }
  }

  /// Open the requested deepLink, if the current Nuvigator is not able to handle
  /// it, and no [INuRouter.onDeepLinkNotFound] is provided, then we try to open the
  /// deepLink in the parent Nuvigator.
  /// [screenType] argument can be used to override the default screenType provided by the to be opened Route
  /// [pushMethod] allows for customizing how the new Route will be pushed into the stack
  /// [parameters] is a helper to inject arguments that would be present in the DeepLink query/path parameters
  Future<R?> open<R extends Object?>(
    String deepLink, {
    DeepLinkPushMethod pushMethod = DeepLinkPushMethod.Push,
    ScreenType? screenType,
    Map<String, dynamic>? parameters,
    bool isFromNative = false,
  }) {
    final route = router.getRoute<R>(
      deepLink: deepLink,
      parameters: parameters,
      isFromNative: isFromNative,
      fromLegacyRouteName: false,
      fallbackScreenType: widget.screenType,
      overrideScreenType: screenType,
    );
    if (route != null) {
      switch (pushMethod) {
        case DeepLinkPushMethod.Push:
          return push<R>(route);
        case DeepLinkPushMethod.PushReplacement:
          return pushReplacement<R, dynamic>(route);
        case DeepLinkPushMethod.PopAndPush:
          pop();
          return push<R>(route);
        default:
          return push<R>(route);
      }
    } else if (router.onDeepLinkNotFound != null) {
      return router.onDeepLinkNotFound!
              (router, Uri.parse(deepLink), false, parameters)
          .then((value) => value as R?);
    } else if (isNested) {
      return parent!.open(deepLink, parameters: parameters);
    } else {
      throw FlutterError(
          'DeepLink $deepLink was not found, and no `onDeepLinkNotFound` was specified.');
    }
  }

  NuvigatorState? parent;

  bool get isNested => parent != null;

  bool get isRoot => this == rootNuvigator;

  INuRouter get rootRouter => rootNuvigator.router;

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
/// are provided by the [NuRouter]. Providing them here will thrown an assertion
/// error.
@immutable
class Nuvigator<T extends INuRouter> extends StatelessWidget {
  Nuvigator({
    required this.router,
    this.initialRoute,
    this.initialDeepLink,
    this.initialArguments,
    Key? key,
    this.observers = const [],
    this.screenType,
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
  })  : _innerKey = key,
        assert(() {
          if (router is NuRouter) {
            return initialDeepLink == null &&
                initialRoute == null &&
                screenType == null;
          }
          return true;
        }());

  /// Creates a [Nuvigator] from a list of [NuRoute]
  static Nuvigator<NuRouterBuilder> routes({
    required String initialRoute,
    required List<NuRoute> routes,
    ScreenType? screenType,
  }) {
    return Nuvigator(
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
  final ScreenType? screenType;
  final WrapperFn? wrapper;
  final List<ObserverBuilder> inheritableObservers;
  final List<NavigatorObserver> observers;
  final Key? _innerKey;
  final String? initialRoute;
  final Uri? initialDeepLink;
  final Map<String, Object>? initialArguments;

  static NuvigatorState? ofRouter<T extends INuRouter>(BuildContext context) {
    final closestNuvigator = context.findAncestorStateOfType<NuvigatorState>();
    return _tryToFindNuvigatorForRouter<T>(closestNuvigator);
  }

  /// Fetches a [NuvigatorState] from the current BuildContext.
  static NuvigatorState<T>? _of<T extends INuRouter>(
    BuildContext context, {
    bool rootNuvigator = false,
  }) {
    if (rootNuvigator) {
      final nuvigatorState =
          context.findRootAncestorStateOfType<NuvigatorState<T>>();
      if (nuvigatorState != null) return nuvigatorState;
    } else {
      final nuvigatorState = ofRouter<T>(context);
      if (nuvigatorState is NuvigatorState<T>) return nuvigatorState;
    }

    return null;
  }

  /// Fetches a [NuvigatorState] from the current BuildContext.
  static NuvigatorState<T> of<T extends INuRouter>(
    BuildContext context, {
    bool rootNuvigator = false,
  }) {
    final result = _of<T>(context, rootNuvigator: rootNuvigator);
    if (result != null) return result;

    throw FlutterError(
        'Nuvigator operation requested with a context that does not include a Nuvigator.\n'
        'The context used to push or pop routes from the Nuvigator must be that of a '
        'widget that is a descendant of a Nuvigator widget.'
        'Also check if the provided Router [T] type exists withing a the Nuvigator context.');
  }

  /// Helper method that allows passing a Nuvigator to a builder function
  Nuvigator call(BuildContext context, [Widget? child]) {
    return this;
  }

  Widget _buildModuleRouter(BuildContext context) {
    return NuRouterLoader(
      // ignore: avoid_as
      router: router as NuRouter,
      builder: (moduleRouter) => _NuvigatorInner(
        router: moduleRouter,
        debug: debug,
        inheritableObservers: inheritableObservers,
        observers: observers,
        initialDeepLink: moduleRouter.initialRoute,
        screenType: moduleRouter.screenType,
        key: _innerKey,
        initialArguments: initialArguments,
        shouldPopRoot: shouldPopRoot,
      ),
    );
  }

  Widget _buildLegacyRouter(BuildContext context) {
    return _NuvigatorInner<T>(
      router: router,
      debug: debug,
      inheritableObservers: inheritableObservers,
      observers: observers,
      initialDeepLink: initialDeepLink?.toString(),
      initialRoute: initialRoute,
      screenType: screenType ?? materialScreenType,
      key: _innerKey,
      initialArguments: initialArguments,
      wrapper: wrapper,
      shouldPopRoot: shouldPopRoot,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (router is NuRouter) {
      return _buildModuleRouter(context);
    } else {
      return _buildLegacyRouter(context);
    }
  }
}
