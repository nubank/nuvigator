import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';

class TestRouter extends SimpleRouter {
  @override
  Map<String, Screen> get screensMap => {
        'firstScreen':
            Screen.material((sc) => null, debugKey: 'testRouterFirstScreen'),
        'secondScreen':
            Screen.cupertino((sc) => null, debugKey: 'testRouterSecondScreen'),
      };

  @override
  Map<String, String> get deepLinksMap => {
        'test/simple': 'firstScreen',
        'test/:id/params': 'secondScreen',
      };
}

class TestRouterWPrefix extends TestRouter {
  @override
  String get deepLinkPrefix => 'prefix/';
}

class GroupTestRouter extends GroupRouter {
  @override
  String get deepLinkPrefix => 'group/';

  @override
  List<Router> get routers => [
        testRouter,
      ];

  @override
  Map<String, Screen> get screensMap => {
        'firstScreen':
            Screen.cupertino((sc) => null, debugKey: 'groupRouterFirstScreen'),
      };

  @override
  Map<String, String> get deepLinksMap => {
        'route/test': 'firstScreen',
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
