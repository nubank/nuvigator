import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'errors.dart';
import 'nuvigator.dart';
import 'router.dart';
import 'screen_route.dart';

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

class GlobalRouter implements Router {
  GlobalRouter({
    @required this.baseRouter,
    GlobalKey<NuvigatorState> nuvigatorKey,
    this.onScreenNotFound,
    this.onDeepLinkNotFound,
  }) {
    this.nuvigatorKey = nuvigatorKey ?? defaultKey;
  }

  static final defaultKey =
      GlobalKey<NuvigatorState>(debugLabel: 'GlobalRouter');

  static GlobalRouter of(BuildContext context) {
    final GlobalRouterProvider globalRouterProvider =
        context.inheritFromWidgetOfExactType(GlobalRouterProvider);
    return globalRouterProvider?.globalRouter;
  }

  final HandleDeepLinkFn onDeepLinkNotFound;
  final Router baseRouter;
  GlobalKey<NuvigatorState> nuvigatorKey;
  final ScreenRoute Function(RouteSettings settings) onScreenNotFound;

  NuvigatorState get nuvigator => nuvigatorKey.currentState;

  @override
  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) {
    return baseRouter.getRouteEntryForDeepLink(deepLink);
  }

  @override
  ScreenRoute getScreen(RouteSettings settings) {
    return baseRouter.getScreen(settings);
  }

  @override
  Route getRoute(RouteSettings settings) {
    final screen = getScreen(settings);
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

  Route _buildNativeRoute(RouteEntry routeEntry) {
    final routeSettings = routeEntry.settings.copyWith(isInitialRoute: false);
    final route = routeEntry.screen(routeSettings).toRoute(routeSettings);
    route.popped.then<dynamic>((dynamic _) async {
      await Future<void>.delayed(Duration(milliseconds: 300));
      await SystemNavigator.pop();
    });
    return route;
  }
}
