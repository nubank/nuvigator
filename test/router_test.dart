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

  group('screen name from deep link', () {
    test('when its a known deep link', () async {
      final testRouter = TestRouter();
      expect(testRouter.getScreenNameFromDeepLink(Uri.parse('test/simple')),
          'firstScreen');
    });

    test('when its an unknown deep link returns null', () async {
      final testRouter = TestRouter();
      expect(
          testRouter.getScreenNameFromDeepLink(Uri.parse('this/doesnt/exist')),
          null);
    });
  });

  group('extracting parameters from deepLink', () {
    test('it can correctly adapt non camelCase keys', () {
      final result = extractDeepLinkParameters(
          Uri.parse('my-route/something?another-one=hello'),
          'my-route/:myArgument');
      expect(result, {
        'myArgument': 'something',
        'another-one': 'hello',
        'anotherOne': 'hello'
      });
    });
    test('it can decode encoded values', () {
      const uri = 'my-route/5f3fd8d0-d02a-434b-801a-c5c3d12faef6/another%20one';
      const deepLinkTemplate = 'my-route/:id/:paramName';
      final result =
          extractDeepLinkParameters(Uri.parse(uri), deepLinkTemplate);
      expect(result, {
        'id': '5f3fd8d0-d02a-434b-801a-c5c3d12faef6',
        'paramName': 'another one'
      });
    });
  });
}
