import 'package:nuvigator/nuvigator.dart';

import '../screen/screen_one.dart';
import '../screen/screen_two.dart';
import 'sample_one_routes.dart';

const screenOneDeepLink =
    'exapp://deepPrefix/sampleOne/screenOne/id_1234_deepLink';

class SampleOneRouter extends SimpleRouter {
  @override
  String get deepLinkPrefix => '/sampleOne/';

  @override
  Map<String, Screen> get screensMap => {
        SampleOneRoutes.screen_one: Screen(s1ScreenOnePage, deeplink: ''),
        SampleOneRoutes.screen_two: s1ScreenTwoPage,
      };

  static ScreenRoute screenOne(String testId) =>
      ScreenRoute(SampleOneRoutes.screen_one, {'testId': testId});

  static ScreenRoute screenTwo() => ScreenRoute(SampleOneRoutes.screen_two);
}

final sampleOneRouter = SampleOneRouter();
