import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import '../screen_route.dart';
import 'nu_route_match.dart';
import 'v1/nu_module.dart';

abstract class NuRoute<T extends NuModule, A extends Object, R extends Object> {
  NuRoute(this._module);

  String get path;

  // TBD
  bool get prefix => false;
  final T _module;

  T get module => _module;

  Future<bool> init(BuildContext context) {
    return SynchronousFuture(true);
  }

  NuRouteMatch<A> getRouteMatch(
    String deepLink, {
    Map<String, dynamic> extraParameters,
  }) {
    return NuRouteMatch(
      pathTemplate: path,
      queryParameters: extraParameters,
      path: deepLink,
    );
  }

  Widget wrapper(BuildContext context, Widget child) => child;

  ScreenType get screenType;

  Widget build(BuildContext context, NuRouteMatch<A> match);

  ScreenRoute<R> getRoute(NuRouteMatch<A> match) => ScreenRoute(
        builder: (context) => build(context, match),
        screenType: screenType,
        wrapper: wrapper,
      );
}
