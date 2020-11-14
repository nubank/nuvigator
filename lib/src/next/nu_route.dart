import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../screen_route.dart';
import 'nu_route_match.dart';
import 'v1/nu_module.dart';

abstract class NuRoute<T extends NuModule, A extends Object, R extends Object> {
  NuRoute(this._delegate);

  String get path;

  // TBD
  bool get prefix => false;
  final T _delegate;

  T get delegate => _delegate;

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

  // TODO
  // Widget wrapper(BuildContext context, Widget child) => child;

  ScreenRoute<R> getRoute(NuRouteMatch<A> match);
}
