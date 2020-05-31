import 'package:example/samples/modules/sample_one/navigation/sample_one_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../bloc/sample_two_bloc.dart';
import '../screen/screen_one.dart';
import '../screen/screen_two.dart';

part 'sample_two_router.g.dart';

@NuRouter()
class SampleTwoRouter extends Router {
  SampleTwoRouter({@required this.testId});

  final String testId;
  final SampleTwoBloc sampleTwoBloc = SampleTwoBloc();

  @override
  WrapperFn get screensWrapper => (BuildContext context, Widget screenWidget) {
        return ChangeNotifierProvider<SampleTwoBloc>.value(
          value: sampleTwoBloc,
          child: screenWidget,
        );
      };

  @NuRoute(deepLink: '/screenOne')
  ScreenRoute screenOne() => ScreenRoute(
        builder: (context) => ScreenOne(
          toScreenTwo: () =>
              nuvigator.openDeepLink('exapp://sampleTwo/screenTwo'),
        ),
      );

  @NuRoute(deepLink: '/screenTwo')
  ScreenRoute<String> screenTwo() => ScreenRoute<String>(
        builder: (context) => ScreenTwo(
          closeFlow: () => nuvigator.closeFlow<String>('ClosedNestedNuvigator'),
          toSampleOne: () => nuvigator.openDeepLink(screenOneDeepLink),
        ),
      );

  @override
  Map<RoutePath, ScreenRouteBuilder> get screensMap => _$screensMap;
}
