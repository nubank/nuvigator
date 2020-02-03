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

  @override
  WrapperFn get screensWrapper => (BuildContext context, Widget screenWidget) {
        return Provider<SampleTwoBloc>.value(
          value: SampleTwoBloc(),
          child: screenWidget,
        );
      };

  @NuRoute()
  ScreenRoute screenOne() => ScreenRoute(
        builder: (context) => ScreenOne(
          toScreenTwo: () => toScreenTwo(),
        ),
      );

  @NuRoute(pushMethods: [PushMethodType.push, PushMethodType.pushReplacement])
  ScreenRoute<String> screenTwo() => ScreenRoute<String>(
        builder: (context) => ScreenTwo(
          closeFlow: () => nuvigator.closeFlow<String>('ClosedNestedNuvigator'),
          toSampleOne: () => openDeepLink<void>(Uri.parse(screenOneDeepLink)),
        ),
      );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;
}
