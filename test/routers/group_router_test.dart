import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';

import '../helpers.dart';

void main() {
  group('getScreen', () {
    test('priority is given to declared screens on this router', () {
      expect(
          testGroupRouter
              .getScreen(const RouteSettings(name: 'firstScreen'))
              .debugKey,
          'groupRouterFirstScreen');
    });

    test('when not found in it, search in sub-routers', () {
      expect(
          testGroupRouter
              .getScreen(const RouteSettings(name: 'secondScreen'))
              .debugKey,
          'testRouterSecondScreen');
    });

    test('screen is not found', () {
      expect(
          testGroupRouter
              .getScreen(const RouteSettings(name: 'notFoundScreen')),
          null);
    });
  });

  group('getDeepLinkFlow', () {
    test('priority is given to declared deeplinks on this router', () async {
      expect(
        await testGroupRouter.getRouteEntryForDeepLink('group/route/test'),
        RouteEntry(
          routeName: 'firstScreen',
          deepLink: 'group/route/test',
          template: 'group/route/test',
        ),
      );
    });

    test('when not found, search in sub-routers appending prefix', () async {
      expect(
        await testGroupRouter.getRouteEntryForDeepLink('group/test/123/params'),
        RouteEntry(
          routeName: 'secondScreen',
          deepLink: 'group/test/123/params',
          template: 'group/test/:id/params',
        ),
      );
    });

    test('return a null Future for not found deeplink', () async {
      expect(await testRouter.getRouteEntryForDeepLink('not/found'), null);
    });
  });
}
