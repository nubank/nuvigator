import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import '../routers.dart';
import '../screen.dart';

/// Simplest type of router. It consists of two Maps, one for RouteName -> Screen
/// and one for DeepLinks => RouteName. It will try to match against those to find
/// a Screen.
abstract class SimpleRouter implements Router {
  final Map<String, Screen> screensMap = {};
  final String deepLinkPrefix = null;

  WrapperFn get screensWrapper => null;

  Future<String> getDeepLinkPrefix() async {
    return deepLinkPrefix ?? '';
  }

  @override
  Screen getScreen({@required String routeName}) {
    assert(routeName != null && routeName.isNotEmpty);

    final screen = screensMap[routeName];
    return screen?.wrapWith(screensWrapper);
  }

  @override
  Future<DeepLinkFlow> getDeepLinkFlowForUrl(String url) async {
    final deepLinkPrefix = await getDeepLinkPrefix();
    for (var screenEntry in screensMap.entries) {
      final currentDeepLink = screenEntry.value.deepLink;
      if (currentDeepLink == null) break;
      final fullTemplate = deepLinkPrefix + currentDeepLink;
      final regExp = pathToRegExp(fullTemplate);
      if (regExp.hasMatch(url))
        return DeepLinkFlow(
          path: url,
          template: fullTemplate,
          routeName: screenEntry.key,
        );
    }
    return null;
  }

  @override
  Route getRoute(RouteSettings settings) {
    return getScreen(routeName: settings.name).toRoute(settings);
  }
}
