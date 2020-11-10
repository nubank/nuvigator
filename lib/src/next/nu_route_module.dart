import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/src/screen_types/generic_screen_type.dart';

import '../../nuvigator.dart';

class RouteMatch<A> {
  RouteMatch({
    this.pathTemplate,
    this.path,
    this.nextPath,
    this.queryParameters,
    this.pathParameters,
    this.arguments,
  });
  final A arguments;
  final String pathTemplate;
  final String path;
  final String nextPath;
  final Map<String, String> queryParameters;
  final Map<String, String> pathParameters;

  Map<String, String> get parameters => {...queryParameters, ...pathParameters};
}

abstract class NuRouteModule<T extends NuModuleRouter, A extends Object,
    R extends Object> {
  NuRouteModule(this._delegate);
  String get path;
  bool get prefix => false;
  T _delegate;
  T get delegate => _delegate;
  Future<bool> init(BuildContext context) {
    return SynchronousFuture(true);
  }

  void install(T delegate) {
    _delegate = delegate;
  }

  bool canHandleDeepLink(String deepLink) {
    return deepLink == path;
  }

  RouteMatch<A> getRouteMatchForDeepLink(String deepLink) {
    return _parseRoute(deepLink);
  }

  RouteMatch<A> _parseRoute(String deepLink) {
    return null;
  }

  Route<R> getRoute(RouteMatch<A> match);
}

class NuRouteConfig {}

abstract class NuModuleRouter extends NuRouter {
  List<NuRouteModule> get modules;
  Widget loadingWidget(BuildContext _) => Container();
  List<NuRouteModule> _modules;
  String get initialRoute;

  Future<void> init(BuildContext context) async {
    final modulesToRegister = <NuRouteModule>[];
    for (final module in modules) {
      final shouldRegister = await module.init(context);
      if (shouldRegister) {
        modulesToRegister.add(module);
      }
    }
    _modules = modulesToRegister;
  }

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _modules.fold(
        {},
        (acc, module) {
          return {
            ...acc,
            RouteDef(module.path, deepLink: module.path): (settings) =>
                ScreenRoute(
                  screenType: GenericScreenType(
                    module.getRoute(
                      module.getRouteMatchForDeepLink(settings.name),
                    ),
                  ),
                  builder: (context) =>
                      Container(), // this is going to be ingored
                ),
          };
        },
      );
}

class Nuvigator2 extends StatelessWidget {
  const Nuvigator2({Key key, this.moduleRouter}) : super(key: key);

  final NuModuleRouter moduleRouter;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: moduleRouter.init(context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
          snapshot.hasData
              ? Nuvigator(
                  router: moduleRouter,
                  initialDeepLink: Uri.parse(moduleRouter.initialRoute),
                )
              : moduleRouter.loadingWidget(context),
    );
  }
}
