import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';

import '../helpers.dart';

void main() {
  group('getScreen', () {
    test('priority is given to declared screens on this router', () {
      expect(testGroupRouter.getScreen(routeName: 'firstScreen').debugKey,
          'groupRouterFirstScreen');
    });

    test('when not found in it, search in sub-routers', () {
      expect(testGroupRouter.getScreen(routeName: 'secondScreen').debugKey,
          'testRouterSecondScreen');
    });

    test('screen is not found', () {
      expect(testGroupRouter.getScreen(routeName: 'notFoundScreen'), null);
    });
  });

  group('getDeepLinkFlow', () {
    test('priority is given to declared deeplinks on this router', () async {
      expect(
        await testGroupRouter.getDeepLinkFlowForUrl('group/route/test'),
        DeepLinkFlow(
          routeName: 'firstScreen',
          path: 'group/route/test',
          template: 'group/route/test',
        ),
      );
    });

    test('when not found, search in sub-routers appending prefix', () async {
      expect(
        await testGroupRouter.getDeepLinkFlowForUrl('group/test/123/params'),
        DeepLinkFlow(
          routeName: 'secondScreen',
          path: 'group/test/123/params',
          template: 'group/test/:id/params',
        ),
      );
    });

    test('return a null Future for not found deeplink', () async {
      expect(await testRouter.getDeepLinkFlowForUrl('not/found'), null);
    });
  });
}
