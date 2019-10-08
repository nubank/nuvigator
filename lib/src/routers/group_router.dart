import 'package:flutter/widgets.dart';

import '../routers.dart';
import '../screen.dart';
import 'simple_router.dart';

/// More complex router that in addition to the features provided by the SimpleRouter
/// it can contains a list of delegate Routers, that will try to match against.
/// This router is used to create a "merge" Router of several other Routers.
abstract class GroupRouter extends SimpleRouter {
  List<Router> routers = [];

  @override
  Screen getScreen({@required String routeName}) {
    assert(routeName != null && routeName.isNotEmpty);

    final screen = super.getScreen(routeName: routeName);
    if (screen != null) return screen;

    for (Router router in routers) {
      final screen = router.getScreen(routeName: routeName);
      if (screen != null) return screen.wrapWith(screensWrapper);
    }
    return null;
  }

  @override
  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) async {
    final thisDeepLinkPrefix = await getDeepLinkPrefix();
    final prefixRegex = RegExp('^$thisDeepLinkPrefix.*');
    if (prefixRegex.hasMatch(deepLink)) {
      final screen = await super.getRouteEntryForDeepLink(deepLink);
      if (screen != null) return screen;
      for (final Router router in routers) {
        final newUrl = deepLink.replaceFirst(thisDeepLinkPrefix, '');
        final subRouterEntry = await router.getRouteEntryForDeepLink(newUrl);
        if (subRouterEntry != null) {
          final fullTemplate = thisDeepLinkPrefix + subRouterEntry.template;
          return RouteEntry(
            screen: subRouterEntry.screen,
            template: fullTemplate,
            deepLink: deepLink,
            routeName: subRouterEntry.routeName,
          );
        }
      }
    }
    return null;
  }
}
