import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:provider/provider.dart';

import 'errors.dart';
import 'routers.dart';

class GlobalRouter extends GroupRouter implements AppRouter {
  GlobalRouter(this._navigatorKey);

  static GlobalRouter of(BuildContext context) =>
      Provider.of<GlobalRouter>(context);

  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  Route getRoute(RouteSettings settings) {
    final screen = getScreen(routeName: settings.name);
    if (screen == null) throw RouteNotFoundException(settings.name);
    return screen.toRoute(settings);
  }

  @override
  Future<bool> canOpenDeepLink(Uri url) async {
    return (await getDeepLinkFlowForUrl(url.host + url.path)) != null;
  }

  @override
  Future<T> openDeepLink<T>(Uri url, [dynamic arguments]) {
    return handleDeepLink(url, false);
  }

  Future<dynamic> handleDeepLink(Uri url, [dynamic fromNative = false]) async {
    final deepLinkFlow = await getDeepLinkFlowForUrl(url.host + url.path);
    final bool isFromNative = fromNative;
    if (deepLinkFlow == null) return null;
    final args = _extractParameters(url, deepLinkFlow);
    if (isFromNative) {
      final route = _buildNativeRoute(args, deepLinkFlow.routeName);
      return _navigatorKey.currentState.push(route);
    }
    return _navigatorKey.currentState
        .pushNamed(deepLinkFlow.routeName, arguments: args);
  }

  // We need this special handling while interacting with native
  Route _buildNativeRoute(Map<String, dynamic> args, String routeName) {
    final routeSettings =
        RouteSettings(arguments: args, name: routeName, isInitialRoute: true);
    final route = getRoute(routeSettings);
    route.popped.then<dynamic>((dynamic _) async {
      await Future<void>.delayed(Duration(milliseconds: 300));
      // Maybe using a Custom channel here? (specially to make it work on iOS)
      await SystemNavigator.pop();
    });
    return route;
  }

  Map<String, dynamic> _extractParameters(Uri url, DeepLinkFlow deepLinkFlow) {
    final parameters = <String>[];
    final regExp = pathToRegExp(deepLinkFlow.template, parameters: parameters);
    final match = regExp.matchAsPrefix(url.host + url.path);
    final args = extract(parameters, match);
    args.addAll(url.queryParameters);
    return args;
  }
}
