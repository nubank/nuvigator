import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import 'package:nuvigator/src/nu_route_settings.dart';

import '../../deeplink.dart';
import '../../legacy_nurouter.dart' as legacy;
import '../../screen_route.dart';
import '../../typings.dart';

/// Extend to create your NuRoute. Contains the configuration of a Route that is
/// going to be presented in a [Nuvigator] by the [NuRouter]
abstract class NuRoute<T extends NuRouter, A extends Object, R extends Object> {
  T _router;

  T get router => _router;

  NuvigatorState get nuvigator => router.nuvigator;

  bool canOpen(String deepLink) => _parser.matches(deepLink);

  bool canOpenByAlias(String alias) {
    if (alias != null && alias.isNotEmpty) {
      return aliases.contains(alias);
    }
    return false;
  }

  ParamsParser<A> get paramsParser => null;

  Future<bool> init(BuildContext context) {
    return SynchronousFuture(true);
  }

  bool get prefix => false;

  ScreenType get screenType;

  String get path;

  Iterable<String> get aliases => [];

  Widget build(BuildContext context, NuRouteSettings<A> settings);

  DeepLinkParser get _parser => DeepLinkParser<A>(
        template: path,
        prefix: prefix,
        argumentParser: paramsParser,
      );

  void _install(T router) {
    assert(_router == null);
    _router = router;
  }

  void dispose() {
    _router = null;
  }

  ScreenRoute<R> _screenRoute({
    String deepLink,
    Map<String, dynamic> extraParameters,
  }) {
    final settings = _parser.toNuRouteSettings(
      deepLink: deepLink,
      arguments: extraParameters,
    );
    return ScreenRoute(
      builder: (context) => build(context, settings),
      screenType: screenType,
      nuRouteSettings: settings,
    );
  }

  ScreenRoute<R> _tryGetScreenRoute({
    String deepLink,
    Map<String, dynamic> extraParameters,
  }) {
    if (canOpen(deepLink)) {
      return _screenRoute(
        deepLink: deepLink,
        extraParameters: extraParameters,
      );
    }
    return null;
  }

  ScreenRoute<R> _tryGetScreenRouteByAlias({
    String alias,
    Map<String, dynamic> extraParameters,
  }) {
    if (canOpenByAlias(alias)) {
      return _screenRoute(
        deepLink: path,
        extraParameters: extraParameters,
      );
    }
    return null;
  }
}

/// Class to create an anonymous [NuRoute] that can be registered in a [NuRouter]
class NuRouteBuilder<A extends Object, R extends Object>
    extends NuRoute<NuRouter, A, R> {
  NuRouteBuilder({
    @required String path,
    @required this.builder,
    Iterable<String> aliases,
    this.initializer,
    this.parser,
    ScreenType screenType,
    bool prefix = false,
  })  : _path = path,
        _prefix = prefix,
        _screenType = screenType,
        _aliases = aliases ?? [];

  final String _path;
  final Iterable<String> _aliases;
  final NuInitFunction initializer;
  final NuRouteParametersParser<A> parser;
  final bool _prefix;
  final ScreenType _screenType;
  final NuWidgetRouteBuilder<A, R> builder;

  @override
  Future<bool> init(BuildContext context) {
    if (initializer != null) {
      return initializer(context);
    }
    return super.init(context);
  }

  @override
  ParamsParser<A> get paramsParser => _parseParameters;

  A _parseParameters(Map<String, dynamic> map) =>
      parser != null ? parser(map) : null;

  @override
  Widget build(BuildContext context, NuRouteSettings<A> settings) {
    return builder(context, this, settings);
  }

  @override
  bool get prefix => _prefix;

  @override
  String get path => _path;

  @override
  ScreenType get screenType => _screenType;

  @override
  Iterable<String> get aliases => _aliases;
}

/// Extend to create your own NuRouter. Responsible for declaring the routes and
/// configuration of the [Nuvigator] where it will be installed.
abstract class NuRouter implements INuRouter {
  NuRouter() {
    _legacyRouters = legacyRouters.whereType<legacy.NuRouter>().toList();
    _routes = [];
    for (final route in registerRoutes) {
      route._install(this);
      _routes.add(route);
    }
  }

  List<NuRoute> _routes;
  List<legacy.NuRouter> _legacyRouters;
  NuvigatorState _nuvigator;

  NuvigatorState get nuvigator => _nuvigator;

  @override
  void install(NuvigatorState nuvigator) {
    assert(_nuvigator == null);
    _nuvigator = nuvigator;
    for (final legacyRouter in _legacyRouters) {
      legacyRouter.install(nuvigator);
    }
  }

  @override
  void dispose() {
    _nuvigator = null;
    for (final route in _routes) {
      route.dispose();
    }
    for (final legacyRouter in _legacyRouters) {
      legacyRouter.dispose();
    }
  }

  @override
  HandleDeepLinkFn onDeepLinkNotFound;

  /// InitialRoute that is going to be rendered
  String get initialRoute;

  /// NuRoutes to be registered in this Module
  List<NuRoute> get registerRoutes;

  /// Backwards compatible with old routers API
  List<INuRouter> get legacyRouters => [];

  /// Override to false if you want a strictly sync initialization in this Router
  /// futures are not going to be awaited to complete!
  bool get awaitForInit => true;

  @override
  T getRouter<T extends INuRouter>() {
    // ignore: avoid_as
    if (this is T) return this as T;
    for (final router in _legacyRouters) {
      final r = router.getRouter<T>();
      if (r != null) return r;
    }
    return null;
  }

  /// ScreenType to be used by the [NuRoute] registered in this Module
  /// ScreenType defined on the [NuRoute] takes precedence over the default one
  /// declared in the [NuModule]
  ScreenType get screenType => null;

  List<NuRoute> get routes => _routes;

  /// While the module is initializing this Widget is going to be displayed
  Widget get loadingWidget => Container();

  /// In case an error happends during the NuRouter initialization, this function will be called with the error
  /// it can handle it accordingly and return a Widget that should be rendered instead of the Nuvigator.
  Widget onError(Error error, NuRouterController controller) => null;

  /// Override to perform some processing/initialization when this module
  /// is first initialized into a [Nuvigator].
  Future<void> init(BuildContext context) {
    return SynchronousFuture(null);
  }

  Future<void> _init(BuildContext context) {
    if (awaitForInit) {
      return init(context).then((value) async {
        for (final route in _routes) {
          await route.init(context);
        }
      });
    } else {
      if (!(init(context) is SynchronousFuture)) {
        throw FlutterError(
            '$this Router initialization do not support Asynchronous initializations,'
            ' but the return type of init() is not a SynchronousFuture. Make '
            'the initialization Sync, or change the Router to support Async '
            'initialization.');
      }
      for (final route in _routes) {
        if (!(route.init(context) is SynchronousFuture)) {
          throw FlutterError(
              '$this Router initialization do not support Asynchronous initializations,'
              ' but the Route $route return type of init() is not a SynchronousFuture.'
              ' Make the initialization Sync, or change the Router to support Async'
              ' initialization.');
        }
      }
      return SynchronousFuture(null);
    }
  }

  ScreenRoute<R> _getScreenRoute<R>(String deepLink,
      {Map<String, dynamic> parameters}) {
    for (final route in routes) {
      final screenRoute = route._tryGetScreenRoute(
        deepLink: deepLink,
        extraParameters: parameters,
      );
      if (screenRoute != null) return screenRoute;
    }
    return null;
  }

  @override
  Route<R> getRoute<R>({
    String deepLink,
    Object parameters,
    @deprecated bool fromLegacyRouteName = false,
    bool isFromNative = false,
    ScreenType fallbackScreenType,
  }) {
    final route = _getScreenRoute<R>(
      deepLink,
      parameters: parameters ?? <String, dynamic>{},
    )?.fallbackScreenType(fallbackScreenType ?? screenType)?.toRoute();
    if (route != null) {
      if (isFromNative) {
        _addNativePopCallBack(route);
      }
      return route;
    }

    // start region: Backwards Compatible Code
    for (final legacyRouter in _legacyRouters) {
      final r = legacyRouter.getRoute<R>(
        deepLink: deepLink,
        parameters: parameters,
        isFromNative: isFromNative,
        fromLegacyRouteName: fromLegacyRouteName,
        fallbackScreenType: fallbackScreenType ?? screenType,
      );
      if (r != null) return r;
    }
    // end region
    return null;
  }

  @override
  Route<R> getRouteByAlias<R>({
    String alias,
    Object parameters,
    @deprecated bool fromLegacyRouteName = false,
    bool isFromNative = false,
    ScreenType fallbackScreenType,
  }) {
    final route = _getScreenRouteByAlias<R>(
      alias,
      parameters: parameters ?? <String, dynamic>{},
    )?.fallbackScreenType(fallbackScreenType ?? screenType)?.toRoute();
    if (route != null) {
      return route;
    }
    return null;
  }

  ScreenRoute<R> _getScreenRouteByAlias<R>(String alias,
      {Map<String, dynamic> parameters}) {
    for (final route in routes) {
      final screenRoute = route._tryGetScreenRouteByAlias(
        alias: alias,
        extraParameters: parameters,
      );
      if (screenRoute != null) return screenRoute;
    }
    return null;
  }

  void _addNativePopCallBack(Route route) {
    route.popped.then<dynamic>((dynamic _) async {
      if (nuvigator.stateTracker.stack.length == 1) {
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
    @required String initialRoute,
    @required List<NuRoute> routes,
    ScreenType screenType,
    Widget loadingWidget,
    bool awaitForInit = true,
    NuInitFunction init,
  })  : _initialRoute = initialRoute,
        _registerRoutes = routes,
        _screenType = screenType,
        _loadingWidget = loadingWidget,
        _awaitForInit = awaitForInit,
        _initFn = init;

  final String _initialRoute;
  final List<NuRoute> _registerRoutes;
  final bool _awaitForInit;
  final ScreenType _screenType;
  final Widget _loadingWidget;
  final NuInitFunction _initFn;

  @override
  bool get awaitForInit => _awaitForInit;

  @override
  String get initialRoute => _initialRoute;

  @override
  List<NuRoute> get registerRoutes => _registerRoutes;

  @override
  ScreenType get screenType => _screenType;

  @override
  Widget get loadingWidget {
    if (_loadingWidget != null) {
      return _loadingWidget;
    }
    return super.loadingWidget;
  }

  @override
  Future<void> init(BuildContext context) {
    if (_initFn != null) {
      return _initFn(context);
    }
    return super.init(context);
  }
}

class NuRouterController {
  const NuRouterController({
    this.reload,
  });

  /// Calling will make the [NuRouter] re-execute its initialization
  final Future<void> Function() reload;
}

class NuRouterLoader extends StatefulWidget {
  const NuRouterLoader({
    Key key,
    this.router,
    this.builder,
  }) : super(key: key);

  final NuRouter router;
  final Widget Function(NuRouter router) builder;

  @override
  _NuRouterLoaderState createState() => _NuRouterLoaderState();
}

class _NuRouterLoaderState extends State<NuRouterLoader> {
  Widget nuvigator;
  bool loading;
  Widget errorWidget;

  Future<void> _reload() {
    return _initModule();
  }

  Future<void> _initModule() async {
    setState(() {
      loading = widget.router.awaitForInit;
      errorWidget = null;
    });
    try {
      await widget.router._init(context);
    } catch (error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      final errorWidget =
          widget.router.onError(error, NuRouterController(reload: _reload));
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

  @override
  void didUpdateWidget(covariant NuRouterLoader oldWidget) {
    if (oldWidget.router != widget.router) {
      _initModule();
      nuvigator = widget.builder(widget.router);
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
      return widget.router.loadingWidget;
    } else if (errorWidget != null) {
      return errorWidget;
    }
    nuvigator ??= widget.builder(widget.router);
    return nuvigator;
  }
}
