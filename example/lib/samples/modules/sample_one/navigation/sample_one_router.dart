import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import '../screen/screen_one.dart';
import '../screen/screen_two.dart';

part 'sample_one_router.g.dart';

const screenOneDeepLink =
    'exapp://deepPrefix/sampleOne/screenOne/id_1234_deepLink';

@NuRouter()
class SampleOneRouter extends BaseRouter {
  @override
  String get deepLinkPrefix => '/sampleOne/';

  @NuRoute(args: {'testId': String})
  final screenOne = const ScreenRoute(
    builder: ScreenOne.builder,
    deepLink: 'screenOne/:testId',
  );

  @NuRoute()
  final screenTwo = const ScreenRoute<int>(
    builder: ScreenTwo.builder,
  );

  @override
  Map<String, ScreenRoute> get screensMap =>
      sampleOneRouter$getScreensMap(this);
}

final sampleOneRouter = SampleOneRouter();
