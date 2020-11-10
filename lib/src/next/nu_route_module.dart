import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../screen_route.dart';
import 'nu_route_match.dart';

abstract class NuRouteModule<T, A extends Object, R extends Object> {
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

  NuRouteMatch<A> getRouteMatchForDeepLink(String deepLink) {
    return _parseRoute(deepLink);
  }

  NuRouteMatch<A> _parseRoute(String deepLink) {
    return null;
  }

  ScreenRoute<R> getRoute(NuRouteMatch<A> match);
}
