import 'package:flutter/widgets.dart';

import '../routers.dart';
import '../screen.dart';
import 'simple_router.dart';

/// More complex router that in addition to the features provided by the SimpleRouter
/// it can contains a list of delegate Routers, that will try to match against.
/// This router is used to create a "merge" Router of several other Routers.
class GroupRouter extends SimpleRouter {
  List<Router> routers = [];

  @override
  Screen getScreen({@required String routeName}) {
    assert(routeName != null && routeName.isNotEmpty);

    final screen = super.getScreen(routeName: routeName);
    if (screen != null) return screen;

    for (Router router in routers) {
      final screen = router.getScreen(routeName: routeName);
      if (screen != null) return screen.withWrappedScreen(screenWrapper);
    }
    return null;
  }

  @override
  Future<DeepLinkFlow> getDeepLinkFlowForUrl(String url) async {
    final thisDeepLinkPrefix = await getDeepLinkPrefix();
    final prefixRegex = RegExp('^$thisDeepLinkPrefix.*');
    if (prefixRegex.hasMatch(url)) {
      final deepLinkFlow = await super.getDeepLinkFlowForUrl(url);
      if (deepLinkFlow != null) return deepLinkFlow;

      for (final Router router in routers) {
        final newUrl = url.replaceFirst(thisDeepLinkPrefix, '');
        final subDeepLinkFlow = await router.getDeepLinkFlowForUrl(newUrl);
        if (subDeepLinkFlow != null) {
          final fullTemplate = thisDeepLinkPrefix + subDeepLinkFlow.template;
          return DeepLinkFlow(
            template: fullTemplate,
            path: url,
            routeName: subDeepLinkFlow.routeName,
          );
        }
      }
    }
    return null;
  }
}
