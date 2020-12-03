import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import 'package:nuvigator/src/nu_route_settings.dart';

import '../../deeplink.dart';
import '../../nurouter.dart';
import '../../screen_route.dart';

typedef NuWidgetRouteBuilder = Widget Function(
    BuildContext context, NuRoute nuRoute, NuRouteSettings<dynamic> settings);

typedef NuRouteParametersParser<A> = A Function(Map<String, dynamic>);

typedef NuInitFunction = Future<bool> Function(BuildContext context);

typedef ParamsParser<T> = T Function(Map<String, dynamic> map);

abstract class NuRoute<T extends NuModuleRouter, A extends Object,
    R extends Object> {
  T _module;

  T get module => _module;

  NuvigatorState get nuvigator => module.nuvigator;

  bool canOpen(String deepLink) => _parser.matches(deepLink);

  ParamsParser<A> get paramsParser => null;

  Future<bool> init(BuildContext context) {
    return SynchronousFuture(true);
  }

  // TBD
  bool get prefix => false;

  ScreenType get screenType;

  String get path;

  Widget build(BuildContext context, NuRouteSettings<A> settings);

  DeepLinkParser get _parser => DeepLinkParser<A>(
        template: path,
        prefix: prefix,
        argumentParser: paramsParser,
      );

  void _install(T module) {
    _module = module;
  }

  ScreenRoute<R> _screenRoute({
    String deepLink,
    Map<String, dynamic> extraParameters,
  }) {
    final settings =
        _parser.toNuRouteSettings(deepLink, parameters: extraParameters);
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
}

class NuRouteBuilder<A extends Object, R extends Object>
    extends NuRoute<NuModuleRouter, A, R> {
  NuRouteBuilder({
    @required String path,
    @required this.builder,
    this.initializer,
    this.parser,
    ScreenType screenType,
    bool prefix = false,
  })  : _path = path,
        _prefix = prefix,
        _screenType = screenType;

  final String _path;
  final NuInitFunction initializer;
  final NuRouteParametersParser<A> parser;
  final bool _prefix;
  final ScreenType _screenType;
  final NuWidgetRouteBuilder builder;

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
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return builder(context, this, settings);
  }

  @override
  bool get prefix => _prefix;

  @override
  String get path => _path;

  @override
  ScreenType get screenType => _screenType;
}

abstract class NuModuleRouter extends NuRouter {
  List<NuRoute> _routes;
  List<NuRouter> _legacyRouters;

  /// InitialRoute that is going to be rendered
  String get initialRoute;

  /// NuRoutes to be registered in this Module
  List<NuRoute> get registerRoutes;

  /// Backwards compatible with old routers API
  List<NuRouter> get legacyRouters => [];

  @override
  List<NuRouter> get routers => _legacyRouters;

  /// ScreenType to be used by the [NuRoute] registered in this Module
  /// ScreenType defined on the [NuRoute] takes precedence over the default one
  /// declared in the [NuModule]
  ScreenType get screenType => null;

  List<NuRoute> get routes => _routes;

  /// While the module is initializing this Widget is going to be displayed
  Widget loadingWidget(BuildContext context) => Container();

  /// Override to perform some processing/initialization when this module
  /// is first initialized into a [Nuvigator].
  Future<void> init(BuildContext context) async {
    return SynchronousFuture(null);
  }

  /// A common wrapper that is going to be applied to all Routes returned by
  /// this Module.
  Widget routeWrapper(BuildContext context, Widget child) {
    return child;
  }

  Future<void> _init(BuildContext context) async {
    _legacyRouters = legacyRouters;
    await init(context);
    _routes = registerRoutes;
    await Future.wait(_routes.map((route) async {
      assert(route._module == null);
      route._install(this);
      await route.init(context);
    }).toList());
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
  @deprecated
  RouteEntry getRouteEntryForDeepLink(String deepLink) {
    throw UnimplementedError(
        'getRouteEntryForDeepLink is deprecated and not implemented for NuModule API');
  }

  @override
  bool canOpenDeepLink(Uri url) {
    return getRoute<dynamic>(url.toString()) != null;
  }

  @override
  @deprecated
  Future<R> openDeepLink<R>(
    Uri url, [
    dynamic arguments,
    bool isFromNative = false,
  ]) {
    return nuvigator.open<R>(url.toString(), parameters: arguments);
  }

  @override
  Route<R> getRoute<R>(
    String deepLink, {
    Map<String, dynamic> parameters,
    @deprecated bool fromLegacyRouteName = false,
    ScreenType fallbackScreenType,
  }) {
    final route = _getScreenRoute<R>(deepLink,
            parameters: parameters ?? <String, dynamic>{})
        ?.fallbackScreenType(fallbackScreenType ?? materialScreenType)
        ?.toRoute();
    if (route != null) return route;

    // start region: Backwards Compatible Code
    for (final legacyRouter in _legacyRouters) {
      if (fromLegacyRouteName) {
        final settings = RouteSettings(name: deepLink, arguments: parameters);
        final r = legacyRouter
            .getScreen(settings)
            ?.fallbackScreenType(screenType)
            ?.toRoute(settings);
        if (r != null) return r;
      } else {
        final r = legacyRouter.getRoute<R>(
          deepLink,
          parameters: parameters,
          fromLegacyRouteName: fromLegacyRouteName,
          fallbackScreenType: fallbackScreenType,
        );
        if (r != null) return r;
      }
    }
    // end region
    return null;
  }
}

class NuRouterBuilder extends NuModuleRouter {
  NuRouterBuilder({
    @required String initialRoute,
    @required List<NuRoute> routes,
    ScreenType screenType,
    WidgetBuilder loadingWidget,
    NuInitFunction init,
  })  : _initialRoute = initialRoute,
        _registerRoutes = routes,
        _screenType = screenType,
        _loadingWidget = loadingWidget,
        _initFn = init;

  final String _initialRoute;
  final List<NuRoute> _registerRoutes;
  final ScreenType _screenType;
  final WidgetBuilder _loadingWidget;
  final NuInitFunction _initFn;

  @override
  String get initialRoute => _initialRoute;

  @override
  List<NuRoute> get registerRoutes => _registerRoutes;

  @override
  ScreenType get screenType => _screenType;

  @override
  Widget loadingWidget(BuildContext context) {
    if (_loadingWidget != null) {
      return _loadingWidget(context);
    }
    return Container();
  }

  @override
  Future<void> init(BuildContext context) {
    if (_initFn != null) {
      return _initFn(context);
    }
    return super.init(context);
  }
}

class NuRouterLoader extends StatefulWidget {
  const NuRouterLoader({
    Key key,
    this.router,
    this.builder,
  }) : super(key: key);

  final NuModuleRouter router;
  final Widget Function(NuModuleRouter router) builder;

  @override
  _NuRouterLoaderState createState() => _NuRouterLoaderState();
}

class _NuRouterLoaderState extends State<NuRouterLoader> {
  bool loading = true;

  void _initModule() {
    widget.router._init(context).then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void didUpdateWidget(covariant NuRouterLoader oldWidget) {
    if (oldWidget.router != widget.router) {
      _initModule();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initModule();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return widget.router.loadingWidget(context);
    }
    return widget.builder(widget.router);
  }
}
