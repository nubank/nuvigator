import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';
import 'package:nuvigator/src/navigation/inu_router.dart';
import 'package:nuvigator/src/navigation/nuvigator_state.dart';

class NuvigatorStateTracker extends NavigatorObserver {
  final List<Route?> stack = [];

  bool get debug => nuvigator!.widget.debug;

  NuvigatorState? get nuvigator => navigator as NuvigatorState<INuRouter>?;

  List<String?> get stackRouteNames =>
      stack.map((it) => it!.settings.name).toList();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    stack.add(route);
    if (debug) debugPrint('didPush $route: $stackRouteNames');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    stack.remove(route);
    if (debug) debugPrint('didPop $route: $stackRouteNames');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    stack.remove(route);
    if (debug) debugPrint('didRemove $route: $stackRouteNames');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final index = stack.indexOf(oldRoute);
    stack[index] = newRoute;
    if (debug) {
      debugPrint('didReplace $oldRoute to $newRoute: $stackRouteNames');
    }
  }
}