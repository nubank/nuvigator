import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import '../nuvigator.dart';
import 'screen.dart';

class RouteEntry {
  RouteEntry({this.deepLink, this.template, this.routeName, this.screen});

  final String deepLink;
  final String template;
  final Screen screen;
  final String routeName;

  Map<String, String> get arguments =>
      _extractParameters(Uri.parse(deepLink), template);

  RouteSettings get settings =>
      RouteSettings(arguments: arguments, name: routeName);

  Map<String, String> _extractParameters(Uri url, String deepLinkTemplate) {
    final parameters = <String>[];
    final regExp = pathToRegExp(deepLinkTemplate, parameters: parameters);
    final match = regExp.matchAsPrefix(url.host + url.path);
    return extract(parameters, match)..addAll(url.queryParameters);
  }

  @override
  String toString() {
    return '$deepLink ($routeName - $template)';
  }

  @override
  int get hashCode => hashList([template, deepLink, routeName]);

  @override
  bool operator ==(dynamic other) {
    if (other is RouteEntry) {
      return other.deepLink == deepLink &&
          other.template == template &&
          other.routeName == routeName;
    }
    return false;
  }
}

/// Base Router class. Provide a basic interface to communicate with other Route
/// components.
abstract class Router {
  Screen getScreen({@required String routeName});

  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) => null;

  Route getRoute(RouteSettings settings) {
    return getScreen(routeName: settings.name).toRoute(settings);
  }
}
