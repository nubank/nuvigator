import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import 'package:nuvigator/src/deeplink.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import '../screen_route.dart';
import 'nu_route_match.dart';
import 'v1/nu_module.dart';

abstract class NuRoute<T extends NuModule, A extends Object, R extends Object> {
  String get path;

  // TBD
  bool get prefix => false;
  T _module;

  T get module => _module;

  NuvigatorState get nuvigator => module.nuvigator;

  DeepLinkParser get parser => DeepLinkParser(path, prefix: prefix);

  A parseParameters(Map<String, dynamic> map) => null;

  void install(T module) {
    _module = module;
  }

  Future<bool> init(BuildContext context) {
    return SynchronousFuture(true);
  }

  NuRouteMatch<A> getRouteMatch(
    String deepLink, {
    Map<String, dynamic> extraParameters,
  }) {
    final regExp = pathToRegExp(path, prefix: prefix);
    if (regExp.hasMatch(deepLink)) {
      return NuRouteMatch<A>(
        args: parseParameters(
          <String, dynamic>{...parser.getParams(deepLink), ...extraParameters},
        ),
        pathTemplate: path,
        extraParameter: extraParameters,
        pathParameters: parser.getPathParams(deepLink),
        queryParameters: parser.getQueryParams(deepLink),
        path: deepLink,
      );
    } else {
      return null;
    }
  }

  Widget wrapper(BuildContext context, Widget child) => child;

  ScreenType get screenType;

  Widget build(BuildContext context, NuRouteMatch<A> match);

  ScreenRoute<R> getScreenRoute(NuRouteMatch<A> match) => ScreenRoute(
        builder: (context) => build(context, match),
        screenType: screenType,
        nuRouteMatch: match,
        wrapper: wrapper,
      );
}
