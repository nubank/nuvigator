import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../bloc/sample_two_bloc.dart';
import '../screen/screen_one.dart';
import '../screen/screen_two.dart';

part 'sample_two_router.g.dart';

@NuRouter()
class SampleTwoRouter extends BaseRouter {
  @override
  WrapperFn get screensWrapper => (BuildContext context, Widget screenWidget) {
        return Provider<SampleTwoBloc>.value(
          value: SampleTwoBloc(),
          child: screenWidget,
        );
      };

  @NuRoute()
  ScreenRoute<String> screenOne({String testId}) => const ScreenRoute(
        builder: ScreenOne.builder,
      );

  @NuRoute(pushMethods: [PushMethodType.push, PushMethodType.pushReplacement])
  ScreenRoute<String> screenTwo() =>
      const ScreenRoute<String>(builder: ScreenTwo.builder);

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap =>
      _$sampleTwoScreensMap(this);
}
