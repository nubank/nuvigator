import 'package:nuvigator/nuvigator.dart';

import '../screen/screen_one.dart';
import '../screen/screen_two.dart';
import 'sample_one_routes.dart';

const screenOneDeepLink =
    'exapp://deepPrefix/sampleOne/screenOne/id_1234_deepLink';

class _SampleOneRouter extends SimpleRouter {
  @override
  String get deepLinkPrefix => '/sampleOne/';

  @override
  Map<String, Screen> get screensMap => {
        SampleOneRoutes.screen_one: s1ScreenOnePage,
        SampleOneRoutes.screen_two: s1ScreenTwoPage,
      };

  @override
  Map<String, String> get deepLinksMap => {
        'screenOne/:testId': SampleOneRoutes.screen_one,
      };
}

final sampleOneRouter = _SampleOneRouter();
