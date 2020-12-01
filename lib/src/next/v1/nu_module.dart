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

abstract class NuRoute<T extends NuModule, A extends Object, R extends Object> {
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

  ScreenRoute<R> _getScreenRoute(
    String deepLink, {
    Map<String, dynamic> extraParameters,
  }) {
    if (canOpen(deepLink)) {
      final settings =
          _parser.toNuRouteSettings(deepLink, parameters: extraParameters);
      return ScreenRoute(
        builder: (context) => build(context, settings),
        screenType: screenType,
        nuRouteSettings: settings,
      );
    }
    return null;
  }
}

class NuRouteBuilder<A extends Object, R extends Object>
    extends NuRoute<NuModule, A, R> {
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
  A parseParameters(Map<String, dynamic> map) =>
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

abstract class NuModule {
  List<NuRoute> _routes;

  // List<NuModule> _subModules;
  NuModuleRouter _router;

  String get initialRoute;

  List<NuRoute> get registerRoutes;

  // List<NuModule> get registerModules => [];

  /// ScreenType to be used by the [NuRoute] registered in this Module
  /// ScreenType defined on the [NuRoute] takes precedence over the default one
  /// declared in the [NuModule]
  ScreenType get screenType => null;

  List<NuRoute> get routes => _routes;

  // TODO: Evaluate the need for subModules
  // List<NuModule> get subModules => _subModules;

  NuvigatorState get nuvigator => _router.nuvigator;

  /// While the module is initializing this Widget is going to be displayed
  Widget loadingWidget(BuildContext context) => Container();

  /// Override to perform some processing/initialization when this module
  /// is first initialized into a [Nuvigator].
  Future<void> init(BuildContext context) async {}

  /// A common wrapper that is going to be applied to all Routes returned by
  /// this Module.
  Widget routeWrapper(BuildContext context, Widget child) {
    return child;
  }

  Future<void> _initModule(BuildContext context, NuModuleRouter router) async {
    assert(_router == null);
    _router = router;
    await init(context);
    _routes = registerRoutes;
    await Future.wait(_routes.map((route) async {
      // Route should not be installed to another module
      assert(route._module == null);
      route._install(this);
      await route.init(context);
    }).toList());
    // await Future.wait(_subModules.map((module) async {
    //   return module._initModule(context, router);
    // }));
  }

  ScreenRoute _getScreenRoute(String deepLink,
      {Map<String, dynamic> parameters}) {
    for (final route in routes) {
      final screenRoute =
          route._getScreenRoute(deepLink, extraParameters: parameters);
      if (screenRoute != null) return screenRoute;
    }
    // TODO: Evaluate the need for subModules
    // for (final subModule in subModules) {
    //   return subModule
    //       ._getScreenRoute(deepLink, parameters: parameters)
    //       ?.wrapWith(routeWrapper);
    // }
    return null;
  }
}

class NuModuleBuilder extends NuModule {
  NuModuleBuilder({
    @required String initialRoute,
    @required List<NuRoute> routes,
    ScreenType screenType,
    WidgetBuilder loadingWidget,
    NuInitFunction init,
  })  : _initialRoute = initialRoute,
        _registerRoutes = routes,
        _screenType = screenType,
        _loadingWidget = loadingWidget,
        _init = init;

  final String _initialRoute;
  final List<NuRoute> _registerRoutes;
  final ScreenType _screenType;
  final WidgetBuilder _loadingWidget;
  final NuInitFunction _init;

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
    if (_init != null) {
      return _init(context);
    }
    return super.init(context);
  }
}

class NuModuleRouter<T extends NuModule> extends NuRouter {
  NuModuleRouter(this.module);

  final T module;

  Future<NuModuleRouter> _initModule(BuildContext context) async {
    await module._initModule(context, this);
    return this;
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
  Future<R> openDeepLink<R>(Uri url,
      [dynamic arguments, bool isFromNative = false]) {
    return nuvigator.open<R>(url.toString(), parameters: arguments);
  }

  @override
  Route<R> getRoute<R>(
    String deepLink, {
    Map<String, dynamic> parameters,
    ScreenType fallbackScreenType,
  }) {
    return module
        ._getScreenRoute(deepLink,
            parameters: parameters ?? <String, dynamic>{})
        ?.fallbackScreenType(fallbackScreenType)
        ?.toRoute();
  }
}

class NuModuleLoader extends StatefulWidget {
  const NuModuleLoader({Key key, this.module, this.builder}) : super(key: key);

  final NuModule module;
  final Widget Function(NuModuleRouter router) builder;

  @override
  _NuModuleLoaderState createState() => _NuModuleLoaderState();
}

class _NuModuleLoaderState extends State<NuModuleLoader> {
  bool loading = true;
  NuModuleRouter router;

  @override
  void initState() {
    router = NuModuleRouter(widget.module);
    router._initModule(context).then((value) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return widget.module.loadingWidget(context);
    }
    return widget.builder(router);
  }
}
