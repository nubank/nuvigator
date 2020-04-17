import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import '../screen/screen_one.dart';
import '../screen/screen_two.dart';

part 'sample_one_router.g.dart';

const screenOneDeepLink = 'exapp://sampleOne/screenOne/id_1234_deepLink';

@NuRouter(deepLinkPrefix: 'exapp://sampleone')
class SampleOneRouter extends Router {
  @NuRoute('/screenOne/:testId')
  ScreenRoute<String> screenOne({@required String testId}) => ScreenRoute(
        builder: (context) => ScreenOne(
          toBack: () => nuvigator.pop('ResultFromScreenOne'),
          toScreenTwo: toScreenTwo,
          toSampleTwo: () => Router.of<SamplesRouter>(context)
              .toSecond(testId: 'From SampleOne'),
        ),
      );

  @NuRoute('/screenTwo')
  ScreenRoute<int> screenTwo() => ScreenRoute<int>(
        builder: (context) => ScreenTwo(
          toSampleTwo: () => Router.of<SamplesRouter>(context)
              .toSecond(testId: 'From SampleOne'),
        ),
      );

  @override
  Map<String, ScreenRouteBuilder> get screensMap => _$screensMap;
}
