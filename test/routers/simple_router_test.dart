import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';

import '../helpers.dart';

void main() {
  group('getScreen', () {
    test('finds the correct screen for `firstScreen`', () {
      expect(
          testRouter
              .getScreen(const RouteSettings(name: 'firstScreen'))
              .debugKey,
          'testRouterFirstScreen');
    });

    test('finds the correct screen for `secondScreen`', () {
      expect(
          testRouter
              .getScreen(const RouteSettings(name: 'secondScreen'))
              .debugKey,
          'testRouterSecondScreen');
    });

    test('returns null if the screen is not found', () {
      expect(testRouter.getScreen(const RouteSettings(name: 'notFound')), null);
    });
  });

  group('getDeepLinkPrefix', () {
    test('if no deepLinkPrefix is provided, return empty string', () async {
      expect(await testRouter.getDeepLinkPrefix(), '');
    });

    test('if there is a deepLinkPrefix', () async {
      expect(await testRouterWPrefix.getDeepLinkPrefix(), 'prefix/');
    });
  });

  group('getDeepLinkFlow', () {
    test('find route name for a simple deeplink', () async {
      expect(
          await testRouter.getRouteEntryForDeepLink('test/simple'),
          RouteEntry(
            routeName: 'firstScreen',
            deepLink: 'test/simple',
            template: 'test/simple',
          ));
    });

    test('find route name for a deeplink with path params', () async {
      expect(
        await testRouter.getRouteEntryForDeepLink('test/123/params'),
        RouteEntry(
          routeName: 'secondScreen',
          deepLink: 'test/123/params',
          template: 'test/:id/params',
        ),
      );
    });

    test('using prefix, finds a route name', () async {
      expect(
        await testRouterWPrefix
            .getRouteEntryForDeepLink('prefix/test/123/params'),
        RouteEntry(
          routeName: 'secondScreen',
          deepLink: 'prefix/test/123/params',
          template: 'prefix/test/:id/params',
        ),
      );
    });

    test('return a null Future for not found deeplink', () async {
      expect(await testRouter.getRouteEntryForDeepLink('not/found'), null);
    });
  });
}
