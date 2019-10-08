import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/src/routers.dart';

import '../nuvigator.dart';
import 'errors.dart';
import 'nuvigator.dart';
import 'routers/group_router.dart';

typedef HandleDeepLinkFn = Future<bool> Function(
    GlobalRouter globalRouter, Uri uri,
    [bool isFromNative, dynamic args]);

class GlobalRouterProvider extends InheritedWidget {
  const GlobalRouterProvider(
      {@required this.globalRouter, @required Widget child})
      : super(child: child);

  final GlobalRouter globalRouter;

  @override
  bool updateShouldNotify(GlobalRouterProvider oldWidget) {
    return oldWidget.globalRouter != globalRouter;
  }
}

class GlobalRouter extends GroupRouter {
  GlobalRouter({
    @required List<Router> routers,
    GlobalKey<NuvigatorState> nuvigatorKey,
    this.onScreenNotFound,
    this.onDeepLinkNotFound,
  }) {
    this.routers = routers;
    this.nuvigatorKey = nuvigatorKey ?? defaultKey;
  }

  static final defaultKey =
      GlobalKey<NuvigatorState>(debugLabel: 'GlobalRouter');

  final HandleDeepLinkFn onDeepLinkNotFound;

  GlobalKey<NuvigatorState> nuvigatorKey;

  final Screen Function(RouteSettings settings) onScreenNotFound;

  static GlobalRouter of(BuildContext context) {
    // ignore: avoid_as
    return (context.inheritFromWidgetOfExactType(GlobalRouterProvider)
            as GlobalRouterProvider)
        ?.globalRouter;
  }

  NuvigatorState get nuvigator => nuvigatorKey.currentState;

  @override
  Route getRoute(RouteSettings settings) {
    final screen = getScreen(routeName: settings.name);
    if (screen == null) {
      if (onScreenNotFound != null)
        return onScreenNotFound(settings).toRoute(settings);
      throw RouteNotFoundException(settings.name);
    }
    return screen.toRoute(settings);
  }

  Future<bool> canOpenDeepLink(Uri url) async {
    return (await getRouteEntryForDeepLink(url.host + url.path)) != null;
  }

  Future<T> openDeepLink<T>(Uri url,
      [dynamic arguments, bool isFromNative = false]) async {
    final routeEntry = await getRouteEntryForDeepLink(url.host + url.path);
    if (routeEntry == null) {
      if (onDeepLinkNotFound != null)
        await onDeepLinkNotFound(this, url, isFromNative, arguments);
      return null;
    }
    if (isFromNative) {
      final route = _buildNativeRoute(routeEntry);
      return nuvigatorKey.currentState.push<T>(route);
    }
    return nuvigatorKey.currentState
        .pushNamed<T>(routeEntry.routeName, arguments: routeEntry.arguments);
  }

  // We need this special handling while interacting with native
  Route _buildNativeRoute(RouteEntry routeEntry) {
    final routeSettings = routeEntry.settings.copyWith(isInitialRoute: true);
    final route = routeEntry.screen.toRoute(routeSettings);
    route.popped.then<dynamic>((dynamic _) async {
      await Future<void>.delayed(Duration(milliseconds: 300));
      await SystemNavigator.pop();
    });
    return route;
  }
}
