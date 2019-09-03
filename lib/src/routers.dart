import 'package:flutter/material.dart';
import 'screen.dart';

class DeepLinkFlow {
  DeepLinkFlow({this.template, this.path, this.routeName});

  final String template;
  final String path;
  final String routeName;
}

/// Base Router class. Provide a basic interface and a helper to build Routes from
/// Screens.
abstract class Router {
  Screen getScreen({String routeName});

  Future<DeepLinkFlow> getDeepLinkFlowForUrl(String url) => null;
}

/// Application Router class. Provides a basic interface and helper to handle
/// deepLinks and get routes.
abstract class AppRouter {
  Future<bool> canOpenDeepLink(Uri url);

  Future<T> openDeepLink<T>(Uri url, [dynamic arguments]);

  Route getRoute(RouteSettings settings);
}
