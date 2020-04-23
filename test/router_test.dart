import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:nuvigator/src/helpers.dart';

import 'helpers.dart';

void main() {
  test('router retrieves the right route for the route name', () {
    final testRouter = TestRouter();
    final route = testRouter
        .getRoute<void>(const RouteSettings(name: 'testapp://test/simple'));
    expect(route.settings.name, 'testapp://test/simple');
  });

  test('getting router from a grouped routers', () async {
    final mainRouter = GroupTestRouter();
    expect(mainRouter.getRouter<TestRouter>(), mainRouter.testRouter);
    expect(mainRouter.getRouter<GroupTestRouter>(), mainRouter);
    expect(mainRouter.getRouter<TestRouterWPrefix>(), null);
  });

  group('matching path', () {
    test('we can match simple paths', () {
      expect(
        pathMatches('testapp://home/here', RoutePath('testapp://home/here')),
        true,
      );
      expect(
        pathMatches('testapp://home/notHere', RoutePath('testapp://home/here')),
        false,
      );
      expect(
        pathMatches('testapp://home', RoutePath('testapp://home/here')),
        false,
      );
      expect(
        pathMatches('testapp://home/here?queryParam=hello',
            RoutePath('testapp://home/here')),
        true,
      );
    });
    test('we can match paths with params', () {
      expect(
        pathMatches('testapp://home/here', RoutePath('testapp://home/:param')),
        true,
      );
      expect(
        pathMatches(
            'testapp://home/here/more', RoutePath('testapp://home/:param')),
        false,
      );
      expect(
        pathMatches(
            'testapp://home/here', RoutePath('testapp://home/:param1/:param2')),
        false,
      );
      expect(
        pathMatches('testapp://home/here?queryParam=hello',
            RoutePath('testapp://home/:param')),
        true,
      );
    });
    test('using prefix pathes', () {
      expect(
        pathMatches('testapp://home/here',
            RoutePath('testapp://home/:param', prefix: true)),
        true,
      );
      expect(
        pathMatches('testapp://home/here/more',
            RoutePath('testapp://home/:param', prefix: true)),
        true,
      );
      expect(
        pathMatches('testapp://home/here',
            RoutePath('testapp://home/:param1/:param2', prefix: true)),
        false,
      );
      expect(
        pathMatches('testapp://home/here?queryParam=hello',
            RoutePath('testapp://home/:param', prefix: true)),
        true,
      );
    });
  });

  group('extracting parameters from deepLink', () {
    test('it can correctly adapt non camelCase keys', () {
      final result = extractDeepLinkParameters(
          'my-route/something?another-one=hello',
          RoutePath('my-route/:myArgument'));
      expect(result, {
        'myArgument': 'something',
        'another-one': 'hello',
        'anotherOne': 'hello'
      });
    });
  });
}
