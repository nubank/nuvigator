import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';

class TestRouter extends Router {
  @override
  Map<RoutePath, ScreenRouteBuilder> get screensMap => {
        RoutePath('testapp://test/simple', prefix: false): (_) => ScreenRoute(
              builder: (sc) => null,
              debugKey: 'testRouterFirstScreen',
              screenType: materialScreenType,
            ),
        RoutePath('testapp://test/:id/params', prefix: false): (_) =>
            ScreenRoute(
              builder: (sc) => null,
              debugKey: 'testRouterSecondScreen',
              screenType: materialScreenType,
            ),
      };
}

class TestRouterWPrefix extends Router {
  @override
  String get deepLinkPrefix => 'testapp://prefix/';

  @override
  Map<RoutePath, ScreenRouteBuilder> get screensMap => {
        RoutePath('test/simple'): (_) => ScreenRoute(
              builder: (sc) => null,
              debugKey: 'testRouterFirstScreen',
              screenType: materialScreenType,
            ),
        RoutePath('test/:id/params'): (_) => ScreenRoute(
              builder: (sc) => null,
              debugKey: 'testRouterSecondScreen',
              screenType: materialScreenType,
            ),
      };
}

class GroupTestRouter extends Router {
  @override
  String get deepLinkPrefix => 'testapp://group/';

  TestRouter testRouter = TestRouter();

  @override
  List<Router> get routers => [
        testRouter,
      ];

  @override
  Map<RoutePath, ScreenRouteBuilder> get screensMap => {
        RoutePath('route/test'): (settings) => ScreenRoute(
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

Widget testApp(Router router, String initialDeepLink, [WrapperFn wrapper]) {
  return MaterialApp(
    builder: Nuvigator(
      router: router,
      initialRoute: initialDeepLink,
      wrapper: wrapper,
    ),
  );
}
