import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';

class TestRouter extends Router {
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

class TestRouterWPrefix extends Router {
  @override
  String get deepLinkPrefix => 'prefix/';

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

class GroupTestRouter extends Router {
  @override
  String get deepLinkPrefix => 'group/';

  TestRouter testRouter = TestRouter();

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

class MockNuvigator extends NuvigatorState {
  MockNuvigator(this.router);

  String routePushed;
  Object argumentsPushed;
  @override
  final Router router;

  @override
  NuvigatorState<Router> get rootNuvigator => this;

  @override
  Future<T> pushNamed<T extends Object>(String routeName,
      {Object arguments}) async {
    routePushed = routeName;
    argumentsPushed = arguments;
    return null;
//    return super.pushNamed(routeName, arguments);
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

Widget testApp(Router router, String initialRoute, [WrapperFn wrapper]) {
  return MaterialApp(
    builder: Nuvigator(
      router: router,
      initialRoute: initialRoute,
      wrapper: wrapper,
    ),
  );
}
