import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'deeplink.dart';
import 'nu_route_settings.dart';
import 'nuvigator.dart';
import 'screen_route.dart';
import 'screen_type.dart';
import 'typings.dart';

/// Extend to create your NuRoute. Contains the configuration of a Route that is
/// going to be presented in a [Nuvigator] by the [NuRouter]
abstract class NuRoute<T extends NuRouter, A extends Object?,
    R extends Object?> {
  NuRoute({
    Map<String, dynamic>? metaData,
  }) : metaData = metaData ?? {};

  T? _router;

  T get router => _router!;

  NuvigatorState get nuvigator => router.nuvigator!;

  bool canOpen(String deepLink) => _parser.matches(deepLink);

  ParamsParser<A>? get paramsParser => null;

  Future<bool> init(BuildContext context) {
    return SynchronousFuture(true);
  }

  final Map<String, dynamic> metaData;

  bool get prefix => false;

  ScreenType? get screenType;

  String get path;

  Widget build(BuildContext context, NuRouteSettings<A?> settings);

  DeepLinkParser get _parser => DeepLinkParser<A>(
        template: path,
        prefix: prefix,
        argumentParser: paramsParser,
      );

  void _install(T router) {
    assert(_router == null,
        'A new instance of the route must be created every time registerRoutes is called. Returning the same instance is not supported. Route path: $path');
    _router = router;
  }

  void dispose() {
    _router = null;
  }

  ScreenRoute<R> _screenRoute({
    required String deepLink,
    Map<String, dynamic>? extraParameters,
  }) {
    final settings = _parser.toNuRouteSettings(
      deepLink: deepLink,
      arguments: extraParameters,
    );
    return ScreenRoute(
      builder: (context) => build(context, settings as NuRouteSettings<A?>),
      screenType: screenType,
      nuRouteSettings: settings,
    );
  }

  ScreenRoute<R>? _tryGetScreenRoute({
    required String deepLink,
    Map<String, dynamic>? extraParameters,
  }) {
    if (canOpen(deepLink)) {
      return _screenRoute(
        deepLink: deepLink,
        extraParameters: extraParameters,
      );
    }
    return null;
  }

  static NullableRoutePredicate withPath(String path) {
    return (Route<dynamic>? route) {
      if (route!.settings is NuRouteSettings) {
        final nuRouteSettings = route.settings as NuRouteSettings;
        return !route.willHandlePopInternally &&
            nuRouteSettings.pathTemplate == path;
      }
      return false;
    };
  }
}

/// Class to create an anonymous [NuRoute] that can be registered in a [NuRouter]
class NuRouteBuilder<A extends Object?, R extends Object?>
    extends NuRoute<NuRouter, A?, R> {
  NuRouteBuilder({
    required String path,
    required this.builder,
    this.initializer,
    this.parser,
    ScreenType? screenType,
    bool prefix = false,
  })  : _path = path,
        _prefix = prefix,
        _screenType = screenType;

  final String _path;
  final NuInitFunction? initializer;
  final NuRouteParametersParser<A>? parser;
  final bool _prefix;
  final ScreenType? _screenType;
  final NuWidgetRouteBuilder<A?, R> builder;

  @override
  Future<bool> init(BuildContext context) {
    if (initializer != null) {
      return initializer!(context);
    }
    return super.init(context);
  }

  @override
  ParamsParser<A?> get paramsParser => _parseParameters;

  A? _parseParameters(Map<String, dynamic> map) =>
      parser != null ? parser!(map) : null;

  @override
  Widget build(BuildContext context, NuRouteSettings<A?> settings) {
    return builder(context, this, settings);
  }

  @override
  bool get prefix => _prefix;

  @override
  String get path => _path;

  @override
  ScreenType? get screenType => _screenType;
}

/// Extend to create your own NuRouter. Responsible for declaring the routes and
/// configuration of the [Nuvigator] where it will be installed.
abstract class NuRouter implements INuRouter {
  NuRouter() {
    if (!lazyRouteRegister) {
      _setupRoutes();
    }
  }

  /// Override to true to call and register the routes only after the NuRouter initialization has been completed
  bool lazyRouteRegister = false;
  List<NuRoute>? _routes;
  NuvigatorState? _nuvigator;

  NuvigatorState? get nuvigator => _nuvigator;

  void _setupRoutes() {
    _routes = [];
    for (final route in registerRoutes) {
      route._install(this);
      _routes!.add(route);
    }
    if (_routes!.isEmpty) {
      throw FlutterError(
        'NuRouter instance created with a empty list of NuRoutes. '
        'This is not supported, please provide at least one valid NuRoute',
      );
    }
  }

  @override
  void install(NuvigatorState nuvigator) {
    assert(_nuvigator == null);
    _nuvigator = nuvigator;
  }

  @override
  void dispose() {
    _nuvigator = null;
    for (final route in _routes!) {
      route.dispose();
    }
  }

  @override
  HandleDeepLinkFn? onDeepLinkNotFound;

  /// InitialRoute that is going to be rendered
  String get initialRoute;

  /// NuRoutes to be registered in this Module
  List<NuRoute> get registerRoutes;

  /// Backwards compatible with old routers API
  List<INuRouter> get legacyRouters => [];

  /// Override if you want to wrap the `builder` function of the NuRoutes
  /// registered in this router with another Widget
  Widget buildWrapper(
    BuildContext context,
    Widget child,
    NuRouteSettings settings,
    NuRoute nuRoute,
  ) =>
      child;

  /// Override to false if you want a strictly sync initialization in this Router
  /// futures are not going to be awaited to complete!
  bool get awaitForInit => true;

  /// ScreenType to be used by the [NuRoute] registered in this Module
  /// ScreenType defined on the [NuRoute] takes precedence over the default one
  /// declared in the [NuModule]
  ScreenType? get screenType => null;

  List<NuRoute> get routes => _routes!;

  /// While the module is initializing this Widget is going to be displayed
  Widget get loadingWidget => Container();

  /// In case an error happens during the NuRouter initialization, this function will be called with the error
  /// it can handle it accordingly and return a Widget that should be rendered instead of the Nuvigator.
  Widget? onError(Object error, NuRouterController controller) => null;

  /// Override to perform some processing/initialization when this module
  /// is first initialized into a [Nuvigator].
  Future<void> init(BuildContext context) {
    return SynchronousFuture(null);
  }

  Future<void> _init(BuildContext context) async {
    final nuRouterInitResult = init(context);
    if (awaitForInit) {
      await nuRouterInitResult;
    } else if (nuRouterInitResult is! SynchronousFuture) {
      throw FlutterError(
          '$this NuRouter initialization do not support Asynchronous initializations,'
          ' but the return type of init() is not a SynchronousFuture. Make '
          'the initialization Sync, or change the Router to support Async '
          'initialization.');
    }
    if (lazyRouteRegister) {
      _setupRoutes();
    }
    for (final route in _routes!) {
      final routeInitResult = route.init(context);
      if (awaitForInit) {
        await routeInitResult;
      } else if (routeInitResult is! SynchronousFuture) {
        throw FlutterError(
            '$this NuRouter initialization do not support Asynchronous initializations,'
            ' but the Route $route return type of init() is not a SynchronousFuture.'
            ' Make the initialization Sync, or change the Router to support Async'
            ' initialization.');
      }
    }
    if (!awaitForInit) {
      return SynchronousFuture(null);
    }
  }

  ScreenRoute<R>? _getScreenRoute<R>(
    String deepLink, {
    Map<String, dynamic>? parameters,
  }) {
    for (final route in routes) {
      final screenRoute = route._tryGetScreenRoute(
        deepLink: deepLink,
        extraParameters: parameters,
      );
      if (screenRoute != null) {
        return screenRoute.wrapWith(
          (context, child) => buildWrapper(
            context,
            child,
            screenRoute.nuRouteSettings,
            route,
          ),
        ) as ScreenRoute<R>?;
      }
    }
    return null;
  }

  @override
  Route<R>? getRoute<R>({
    required String deepLink,
    Object? parameters,
    bool isFromNative = false,
    ScreenType? overrideScreenType,
    ScreenType? fallbackScreenType,
  }) {
    final route = _getScreenRoute<R>(
      deepLink,
      parameters: parameters as Map<String, dynamic>? ?? <String, dynamic>{},
    )
        ?.fallbackScreenType(fallbackScreenType ?? screenType)
        .copyWith(screenType: overrideScreenType)
        .toRoute();
    if (route != null) {
      if (isFromNative) {
        _addNativePopCallBack(route);
      }
      return route;
    }
    return null;
  }

  void _addNativePopCallBack(Route route) {
    route.popped.then<dynamic>((dynamic _) async {
      if (nuvigator!.stateTracker!.stack.length == 1) {
        // We only have the backdrop route in the stack
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await SystemNavigator.pop();
      }
    });
  }
}

/// Builder class for creating an anonymous [NuRouter]
class NuRouterBuilder extends NuRouter {
  NuRouterBuilder({
    required String initialRoute,
    required List<NuRoute> routes,
    ScreenType? screenType,
    Widget? loadingWidget,
    bool awaitForInit = true,
    NuInitFunction? init,
  })  : _initialRoute = initialRoute,
        _registerRoutes = routes,
        _screenType = screenType,
        _loadingWidget = loadingWidget,
        _awaitForInit = awaitForInit,
        _initFn = init;

  final String _initialRoute;
  final List<NuRoute> _registerRoutes;
  final bool _awaitForInit;
  final ScreenType? _screenType;
  final Widget? _loadingWidget;
  final NuInitFunction? _initFn;

  @override
  bool get awaitForInit => _awaitForInit;

  @override
  String get initialRoute => _initialRoute;

  @override
  List<NuRoute> get registerRoutes => _registerRoutes;

  @override
  ScreenType? get screenType => _screenType;

  @override
  Widget get loadingWidget {
    if (_loadingWidget != null) {
      return _loadingWidget!;
    }
    return super.loadingWidget;
  }

  @override
  Future<void> init(BuildContext context) {
    if (_initFn != null) {
      return _initFn!(context);
    }
    return super.init(context);
  }
}

class NuRouterController {
  const NuRouterController({
    this.reload,
  });

  /// Calling will make the [NuRouter] re-execute its initialization
  final Future<void> Function()? reload;
}

class NuRouterLoader extends StatefulWidget {
  const NuRouterLoader({
    Key? key,
    required this.router,
    required this.builder,
    this.shouldRebuild,
  }) : super(key: key);

  final NuRouter router;
  final ShouldRebuildFn? shouldRebuild;
  final Widget Function(NuRouter router) builder;

  @override
  _NuRouterLoaderState createState() => _NuRouterLoaderState();
}

class _NuRouterLoaderState extends State<NuRouterLoader> {
  Widget? nuvigator;
  NuRouter? router;
  late bool loading;
  Widget? errorWidget;

  Future<void> _reload() {
    return _initModule();
  }

  Future<void> _initModule() async {
    router = widget.router;
    setState(() {
      loading = router!.awaitForInit;
      errorWidget = null;
    });
    try {
      await router!._init(context);
    } catch (error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      final errorWidget =
          router!.onError(error, NuRouterController(reload: _reload));
      if (errorWidget != null) {
        setState(() {
          this.errorWidget = errorWidget;
        });
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  bool get _shouldRebuildProvided => widget.shouldRebuild != null;

  @override
  void didUpdateWidget(covariant NuRouterLoader oldWidget) {
    if (_shouldRebuildProvided &&
        widget.shouldRebuild!(oldWidget.router, widget.router)) {
      _initModule();
      nuvigator = widget.builder(router!);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _initModule();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return router!.loadingWidget;
    } else if (errorWidget != null) {
      return errorWidget!;
    }
    if (_shouldRebuildProvided) {
      nuvigator ??= widget.builder(router!);
      return nuvigator!;
    } else {
      return widget.builder(router!);
    }
  }
}
