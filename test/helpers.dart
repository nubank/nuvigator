import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';

class TestRouter extends BaseRouter {
  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => {
        RouteDef('firstScreen', deepLink: 'test/simple'): (_) => ScreenRoute(
              builder: (sc) => null,
              debugKey: 'testRouterFirstScreen',
              screenType: materialScreenType,
            ),
        RouteDef('secondScreen', deepLink: 'test/:id/params'): (_) =>
            ScreenRoute(
              builder: (sc) => null,
              debugKey: 'testRouterSecondScreen',
              screenType: materialScreenType,
            ),
      };
}

class TestRouterWPrefix extends TestRouter {
  @override
  String get deepLinkPrefix => 'prefix/';
}

class GroupTestRouter extends BaseRouter {
  @override
  String get deepLinkPrefix => 'group/';

  @override
  List<Router> get routers => [
        testRouter,
      ];

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => {
        RouteDef('firstScreen', deepLink: 'route/test'): (settings) =>
            ScreenRoute(
              builder: (sc) => null,
              debugKey: 'groupRouterFirstScreen',
              screenType: cupertinoScreenType,
            ),
      };
}

final testRouter = TestRouter();
final testRouterWPrefix = TestRouterWPrefix();
final testGroupRouter = GroupTestRouter();

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
