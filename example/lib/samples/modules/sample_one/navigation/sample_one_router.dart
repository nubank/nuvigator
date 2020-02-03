import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import '../screen/screen_one.dart';
import '../screen/screen_two.dart';

part 'sample_one_router.g.dart';

const screenOneDeepLink =
    'exapp://deepPrefix/sampleOne/screenOne/id_1234_deepLink';

@NuRouter()
class SampleOneRouter extends Router {
  @override
  Future<String> get deepLinkPrefix async => '/sampleOne';

  @NuRoute(deepLink: '/screenOne/:testId')
  ScreenRoute<String> screenOne({@required String testId}) => ScreenRoute(
        builder: (context) => ScreenOne(
          toBack: () => nuvigator.pop('ResultFromScreenOne'),
          toScreenTwo: toScreenTwo,
          toSampleTwo: () => Router.of<SamplesRouter>(context)
              .toSecond(testId: 'From SampleOne'),
        ),
      );

  @NuRoute()
  ScreenRoute<int> screenTwo() => ScreenRoute<int>(
        builder: (context) => ScreenTwo(
          toSampleTwo: () => Router.of<SamplesRouter>(context)
              .toSecond(testId: 'From SampleOne'),
        ),
      );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;
}
