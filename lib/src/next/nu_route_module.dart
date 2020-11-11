import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../screen_route.dart';
import 'nu_route_match.dart';

abstract class NuRouteModule<T, A extends Object, R extends Object> {
  NuRouteModule(this._delegate);

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

  ScreenRoute<R> getRoute(NuRouteMatch<A> match);
}
