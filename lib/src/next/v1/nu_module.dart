import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import 'package:nuvigator/src/nu_route_settings.dart';

import '../../deeplink.dart';
import '../../nurouter.dart';
import '../../screen_route.dart';

abstract class NuRoute<T extends NuModule, A extends Object, R extends Object> {
  T _module;

  T get module => _module;

  NuvigatorState get nuvigator => module.nuvigator;

  bool canOpen(String deepLink) => _parser.matches(deepLink);

  A parseParameters(Map<String, dynamic> map) => null;

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
        argumentParser: parseParameters,
      );

  NuRouteSettings<A> _getNuRouteSettings(
    String deepLink, {
    Map<String, dynamic> extraParameters,
  }) {
    if (canOpen(deepLink)) {
      return _parser.toNuRouteSettings(deepLink, parameters: extraParameters);
    } else {
      return null;
    }
  }

  void _install(T module) {
    _module = module;
  }

  ScreenRoute<R> _getScreenRoute(NuRouteSettings<A> settings) => ScreenRoute(
        builder: (context) => build(context, settings),
        screenType: screenType,
        nuRouteSettings: settings,
      );
}

abstract class NuModule {
  NuModule() {
    _subModules = registerModules;
    _routes = registerRoutes;
    for (final route in _routes) {
      route._install(this);
    }
  }

  List<NuRoute> _routes;
  List<NuModule> _subModules;
  NuModuleRouter _router;

  String get initialRoute => null;

  List<NuRoute> get registerRoutes;

  List<NuModule> get registerModules => [];

  List<NuRoute> get routes => _routes;

  List<NuModule> get subModules => _subModules;

  NuvigatorState get nuvigator => _router.nuvigator;

  /// While the module is initializing this Widget is going to be displayed
  Widget loadingWidget(BuildContext _) => Container();

  /// Override to perform some processing/initialization when this module
  /// is first initialized into a [Nuvigator].
  Future<void> init(BuildContext context) async {}

  /// A common wrapper that is going to be applied to all Routes returned by
  /// this Module.
  Widget routeWrapper(BuildContext context, Widget child) {
    return child;
  }

  void _syncInit(NuModuleRouter router) {
    _router = router;
    for (final subModule in _subModules) {
      subModule._syncInit(router);
    }
  }

  Future<void> _initModule(BuildContext context, NuModuleRouter router) async {
    await init(context);
    await Future.wait(_routes.map((route) async {
      await route.init(context);
    }));
    await Future.wait(_subModules.map((module) async {
      return module._initModule(context, router);
    }));
  }

  ScreenRoute _getScreenRoute(String deepLink,
      {Map<String, dynamic> parameters}) {
    for (final route in routes) {
      final nuRouteSettings =
          route._getNuRouteSettings(deepLink, extraParameters: parameters);
      if (nuRouteSettings != null) {
        return route._getScreenRoute(nuRouteSettings)?.wrapWith(routeWrapper);
      }
    }
    for (final subModule in subModules) {
      return subModule
          ._getScreenRoute(deepLink, parameters: parameters)
          ?.wrapWith(routeWrapper);
    }
    return null;
  }
}

class NuModuleRouter<T extends NuModule> extends NuRouter {
  NuModuleRouter(this.module) {
    module._syncInit(this);
  }

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
        .fallbackScreenType(fallbackScreenType)
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
