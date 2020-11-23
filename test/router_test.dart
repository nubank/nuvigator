import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  test('router retrieves the right screen for the route name', () {
    final testRouter = TestRouter();
    final screen =
        testRouter.getScreen(const RouteSettings(name: 'firstScreen'));
    expect(screen.debugKey, 'testRouterFirstScreen');
  });

  test('router retrieves the right screen for the deepLink', () async {
    final testRouter = TestRouter();
    final routeEntry = testRouter.getRouteEntryForDeepLink('test/simple');
    expect(routeEntry.value(const RouteSettings()).debugKey,
        'testRouterFirstScreen');
  });

  test('router can open deepLink', () async {
    final testRouter = TestRouter();
    expect(testRouter.canOpenDeepLink(Uri.parse('test/simple')), true);
    expect(testRouter.canOpenDeepLink(Uri.parse('test/simple/another')), false);
    expect(testRouter.canOpenDeepLink(Uri.parse('test/')), false);
    expect(testRouter.canOpenDeepLink(Uri.parse('test/123/params')), true);
    expect(testRouter.canOpenDeepLink(Uri.parse('test/params')), false);
    expect(testRouter.canOpenDeepLink(Uri.parse('test//params')), false);
  });

  test('router on deepLinkNotFound', () async {
    final testRouter = TestRouter();
    var notFound = false;
    final mockNuvigator = MockNuvigator(testRouter);
    testRouter.nuvigator = mockNuvigator;
    testRouter.onDeepLinkNotFound = (router, deepLink, [_, dynamic __]) async {
      notFound = true;
    };
    await testRouter.openDeepLink<void>(Uri.parse('not-found'));
    expect(notFound, true);
    expect(mockNuvigator.routePushed, null);
  });

  test('router open deepLink correctly', () async {
    final testRouter = TestRouter();
    final mockNuvigator = MockNuvigator(testRouter);
    testRouter.nuvigator = mockNuvigator;
    await testRouter.openDeepLink<void>(Uri.parse('test/simple'));
    expect(mockNuvigator.routePushed, 'firstScreen');
  });

  test('router open deepLink with arguments', () async {
    final testRouter = TestRouter();
    final mockNuvigator = MockNuvigator(testRouter);
    testRouter.nuvigator = mockNuvigator;
    await testRouter
        .openDeepLink<void>(Uri.parse('test/12345/params?extraParam=hello'));
    expect(mockNuvigator.routePushed, 'secondScreen');
    expect(
        mockNuvigator.argumentsPushed, {'id': '12345', 'extraParam': 'hello'});
  });

  test('getting router from a grouped routers', () async {
    final mainRouter = GroupTestRouter();
    expect(mainRouter.getRouter<TestRouter>(), mainRouter.testRouter);
    expect(mainRouter.getRouter<GroupTestRouter>(), mainRouter);
    expect(mainRouter.getRouter<TestRouterWPrefix>(), null);
  });
}
