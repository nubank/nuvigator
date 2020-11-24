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
  Widget loadingWidget(BuildContext _) => Container();

  /// Override to perform some processing/initialization when this module
  /// is first initialized into a [Nuvigator].
  Future<void> init(BuildContext context) async {}

  /// A common wrapper that is going to be applied to all Routes returned by
  /// this Module.
  Widget routeWrapper(BuildContext context, Widget child) {
    return child;
  }

  Future<void> _initModule(BuildContext context, NuModuleRouter router) async {
    _router = router;
    await init(context);
    _routes = registerRoutes;
    await Future.wait(_routes.map((route) async {
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
      return route._getScreenRoute(deepLink, extraParameters: parameters);
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
