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
  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) async {
    final deepLinkPrefix = await getDeepLinkPrefix();
    for (var screenEntry in screensMap.entries) {
      final screen = screenEntry.value;
      final currentDeepLink = screenEntry.value.deepLink;
      if (currentDeepLink == null) break;
      final fullTemplate = deepLinkPrefix + currentDeepLink;
      final regExp = pathToRegExp(fullTemplate);
      if (regExp.hasMatch(deepLink)) {
        return RouteEntry(
          deepLink: deepLink,
          template: fullTemplate,
          screen: screen,
          routeName: screenEntry.key,
        );
      }
    }
    return null;
  }

  @override
  Route getRoute(RouteSettings settings) {
    return getScreen(routeName: settings.name).toRoute(settings);
  }
}

/// Router that accepts just one Route
//class SingleRouter extends Router {
//  SingleRouter({
//    @required this.routeName,
//    @required this.screen,
//    this.deepLink,
//  });
//
//  final String routeName;
//  final String deepLink;
//  final Screen screen;
//
//  @override
//  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) async {
//    if (pathToRegExp(this.deepLink).hasMatch(deepLink)) {
//      return RouteEntry(
//        routeName: routeName,
//        deepLink: deepLink,
//        screen: screen,
//        template: this.deepLink,
//      );
//    }
//    return null;
//  }
//
//  @override
//  Screen getScreen({String routeName}) {
//    return routeName == this.routeName ? screen : null;
//  }
//}
//
//abstract class NuRoute implements Router {
//  final deepLink = '';
//  final routeName = '';
//  final screen = Screen(
//    builder: (ctx) => null,
//  );
//
//  @override
//  Route getRoute(RouteSettings settings) {
//    return screen.toRoute(settings);
//  }
//
//  @override
//  Future<RouteEntry> getRouteEntryForDeepLink(String deepLink) async {
//    if (this.deepLink == deepLink)
//      return RouteEntry(
//        template: this.deepLink,
//        screen: screen,
//        deepLink: deepLink,
//        routeName: routeName,
//      );
//    return null;
//  }
//
//  @override
//  Screen<Object> getScreen({String routeName}) {
//    if (routeName == this.routeName) return screen;
//    return null;
//  }
//}
//
//@NuRouter()
//class MyRouter extends SimpleRouter {
//  @NuRoute(args: {'testId': String})
//  final Screen paymentResume = Screen(builder: (ctx) {
//    return const Text('');
//  });
//  @NuRoute(args: {'myParams': String})
//  final Screen paymentSucceeded = Screen();
//  @NuRoute()
//  final Screen paymentSimulations = Screen();
//  @Route({}, subRouter: ContractRouter)
//  final Screen contractFlow = Screen();

//  @override
//  Map<String, Screen> get screensMap => $MyRouter.screensMap(this);
//}
//
//class MyRouterNavigation {
//  MyRouterNavigation(this.nuvigator);
//
//  final NuvigatorState nuvigator;
//
//  void paymentResume({String testId}) {
//    nuvigator.pushNamed('paymentResume', arguments: {'testId': testId});
//  }
//}
//
//class GRouter extends Router {
//  @Router()
//  final MyRouter myRouter = MyRouter();
//
//  List<Router> get getRouters => $GRouter.routers(this);
//}
