import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import '../nuvigator.dart';
import 'errors.dart';
import 'nuvigator.dart';
import 'routers/group_router.dart';
import 'routers.dart';

class GlobalRouterProvider extends InheritedWidget {
  const GlobalRouterProvider(
      {@required this.globalRouter, @required Widget child})
      : super(child: child);

  final GlobalRouter globalRouter;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}

class GlobalRouter extends GroupRouter implements AppRouter {
  GlobalRouter({
    @required List<Router> routers,
    GlobalKey<NuvigatorState> nuvigatorKey,
    this.deepLinkNotFound,
  }) {
    this.routers = routers;
    this.nuvigatorKey = nuvigatorKey ?? defaultKey;
  }

  static final defaultKey =
      GlobalKey<NuvigatorState>(debugLabel: 'GlobalRouter');

  final Future<bool> Function(GlobalRouter globalRouter, Uri uri,
      [bool isFromNative, dynamic args]) deepLinkNotFound;
  GlobalKey<NuvigatorState> nuvigatorKey;

  static GlobalRouter of(BuildContext context) {
    // ignore: avoid_as
    return (context.inheritFromWidgetOfExactType(GlobalRouterProvider)
            as GlobalRouterProvider)
        .globalRouter;
  }

  NuvigatorState get nuvigator => nuvigatorKey.currentState;

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
  Future<T> openDeepLink<T>(Uri url,
      [dynamic arguments, bool isFromNative = false]) async {
    final deepLinkFlow = await getDeepLinkFlowForUrl(url.host + url.path);
    if (deepLinkFlow == null) {
      if (deepLinkNotFound != null)
        await deepLinkNotFound(this, url, isFromNative, arguments);
      return null;
    }
    final args = _extractParameters(url, deepLinkFlow);
    if (isFromNative) {
      final route = _buildNativeRoute(args, deepLinkFlow.routeName);
      return nuvigatorKey.currentState.push<T>(route);
    }
    return nuvigatorKey.currentState
        .pushNamed<T>(deepLinkFlow.routeName, arguments: args);
  }

  // We need this special handling while interacting with native
  Route _buildNativeRoute(Map<String, dynamic> args, String routeName) {
    final routeSettings =
        RouteSettings(arguments: args, name: routeName, isInitialRoute: true);
    final route = getRoute(routeSettings);
    route.popped.then<dynamic>((dynamic _) async {
      await Future<void>.delayed(Duration(milliseconds: 300));
      await SystemNavigator.pop();
    });
    return route;
  }

  Map<String, dynamic> _extractParameters(Uri url, DeepLinkFlow deepLinkFlow) {
    final parameters = <String>[];
    final regExp = pathToRegExp(deepLinkFlow.template, parameters: parameters);
    final match = regExp.matchAsPrefix(url.host + url.path);
    return extract(parameters, match)..addAll(url.queryParameters);
  }
}
