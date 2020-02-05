import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';

import 'helpers.dart';

void main() {
  test('router retrieves the right screen for the route name', () {
    final testRouter = TestRouter();
    final screen =
        testRouter.getScreen(const RouteSettings(name: 'firstScreen'));
    expect(screen.debugKey, 'testRouterFirstScreen');
  });

  test('router onScreenNotFound', () {
    final testRouter = TestRouter();
    bool notFound = false;
    testRouter.onScreenNotFound = (settings) {
      notFound = true;
      return ScreenRoute(debugKey: 'screenNotFound', builder: (_) => null);
    };
    final screen =
        testRouter.getScreen(const RouteSettings(name: 'notExisting'));
    expect(screen.debugKey, 'screenNotFound');
    expect(notFound, true);
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
    bool notFound = false;
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

  group('initial route', () {
    test('when its a known deep link without prefix', () async {
      final testRouter = TestRouter();
      expect(testRouter.getInitialRoute('test/simple'), 'firstScreen');
    });

    test('when its a know deep link with prefix', () async {
      final testRouterWPrefix = TestRouterWPrefix();
      expect(testRouterWPrefix.getInitialRoute('prefix/test/simple'),
          'firstScreen');
    });

    test('when its a route name', () {
      final testRouter = TestRouter();
      expect(testRouter.getInitialRoute('firstScreen'), 'firstScreen');
    });
    test('when its a route name from a prefixed router', () async {
      final testRouterWPrefix = TestRouterWPrefix();
      expect(testRouterWPrefix.getInitialRoute('firstScreen'), 'firstScreen');
    });
  });
}
