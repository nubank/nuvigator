import 'dart:async';

import 'package:flutter/widgets.dart';

import '../nu_route_module.dart';

class NuvigatorPage<A, T> extends Page<T> {
  const NuvigatorPage({this.module, this.routeMatch});

  final NuRouteModule module;
  final RouteMatch<A> routeMatch;

  @override
  Route<T> createRoute(BuildContext context) {
    return module.getRoute(routeMatch);
  }
}

abstract class NuRouterDelegate extends RouterDelegate<NuRouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NuRouteConfig> {
  final List<Page> _pages = [];

  GlobalKey<NavigatorState> _navigatorKey;
  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  NuRouterDelegate nuvigator;
  List<NuRouteModule> _modules;
  Widget loadingWidget(BuildContext _) => Container();
  List<NuRouteModule> get modules;

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

  // Ignores the entire current stack and replaces just by this deepLink
  void setDeepLink(String deepLink) {}

  Route<R> getRoute<R>(BuildContext context, RouteSettings settings) {
    for (final module in _modules) {
      if (module.canHandleDeepLink(settings.name)) {
        final match = module.getRouteMatchForDeepLink(settings.name);
        return module.getRoute(match);
      }
    }
    return null;
  }

  // Supporting async deepLink resolution is a cool feature, we just need to check how to handle loading in those scenarios.
  Future<R> openDeepLink<R>(String deepLink) async {
    for (final module in _modules) {
      if (module.canHandleDeepLink(deepLink)) {
        final completer = Completer<dynamic>();
        final routeMatch = module.getRouteMatchForDeepLink(deepLink);
        final page = NuvigatorPage<dynamic, dynamic>(
          module: module,
          routeMatch: routeMatch,
          // onPop: (result) {
          //   completer.complete(result);
          // },
        );
        _pages.add(page);
        return completer.future;
      }
    }
    // No module matched for this deepLink, what we should do?
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Navigator(
            key: _navigatorKey,
            // If we can still use the Navigator instead of a custom override it would be cool. We would probably need to move a lot of logic to this delegate to emulate the functionaly we want
            initialRoute: initialRoute,
            onPopPage: (route, dynamic result) {
              route.didPop(result);
              // ignore: avoid_as
              final page = route.settings as Page<dynamic>;
              _pages.removeWhere((element) => element.key == page.key);
              notifyListeners();
              return true;
            },
            pages: _pages,
          );
        } else {
          return loadingWidget(context);
        }
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    _pages.removeLast();
    notifyListeners();
    return true;
  }

  @override
  Future<void> setNewRoutePath(NuRouteConfig configuration) {
    throw UnimplementedError();
  }
}
