import 'package:example/samples/modules/sample_two/screen/screen_two.dart';
import 'package:routing/routing.dart';

import '../screen/screen_one.dart';
import 'sample_two_routes.dart';

class _SampleTwoRouter extends SimpleRouter with FlowRouter<String> {
  @override
  Map<String, Screen> get screensMap => {
    SampleTwoRoutes.screen_one: S2ScreenOnePage,
    SampleTwoRoutes.screen_two: S2ScreenTwoPage,
  };

  @override
  String get initialRouteName => SampleTwoRoutes.screen_one;
}

final sampleTwoRouter = _SampleTwoRouter();