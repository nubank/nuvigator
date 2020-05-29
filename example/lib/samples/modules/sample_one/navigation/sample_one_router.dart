import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import '../screen/screen_one.dart';
import '../screen/screen_two.dart';

part 'sample_one_router.g.dart';

const screenOneDeepLink = 'exapp://sampleOne/screenOne/id_1234_deepLink';

@NuRouter()
class SampleOneRouter extends Router {
  @override
  String get prefix => 'exapp://sampleOne';

  @NuRoute(deepLink: '/screenOne/:testId')
  ScreenRoute<String> screenOne({@required String testId}) => ScreenRoute(
        builder: (context) => ScreenOne(
          toBack: () => nuvigator.pop('ResultFromScreenOne'),
          toScreenTwo: toScreenTwo,
          toSampleTwo: () => Router.of<SamplesRouter>(context)
              .toSecond(testId: 'From SampleOne'),
        ),
      );

  @NuRoute(deepLink: '/screenTwo')
  ScreenRoute<int> screenTwo() => ScreenRoute<int>(
        builder: (context) => ScreenTwo(
          toSampleTwo: () => Router.of<SamplesRouter>(context)
              .toSecond(testId: 'From SampleOne'),
        ),
      );

  @override
  Map<RoutePath, ScreenRouteBuilder> get screensMap => _$screensMap;
}
