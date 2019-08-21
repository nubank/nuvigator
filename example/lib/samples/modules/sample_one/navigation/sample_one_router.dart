import 'package:example/samples/modules/sample_one/screen/screen_two.dart';
import 'package:routing/routing.dart';

import '../screen/screen_one.dart';
import 'sample_one_routes.dart';

const screenOneDeepLink = 'exapp://deepPrefix/sampleOne/screenOne/id_1234_deepLink';

class _SampleOneRouter extends SimpleRouter {
  @override
  String get deepLinkPrefix => '/sampleOne/';

  @override
  Map<String, Screen> get screensMap => {
    SampleOneRoutes.screen_one: S1ScreenOnePage,
    SampleOneRoutes.screen_two: S1ScreenTwoPage,
  };

  @override
  Map<String, String> get deepLinksMap => {
    'screenOne/:testId':
    SampleOneRoutes.screen_one,
  };
}

final sampleOneRouter = _SampleOneRouter();