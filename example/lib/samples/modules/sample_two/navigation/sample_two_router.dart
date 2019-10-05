import 'package:example/samples/modules/sample_two/bloc/screen_one_bloc.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../bloc/sample_flow_bloc.dart';
import '../bloc/sample_two_bloc.dart';
import '../screen/screen_one.dart';
import '../screen/screen_two.dart';
import 'sample_two_routes.dart';

class SampleTwoRouter extends SimpleRouter {
  @override
  Map<String, Screen> get screensMap => {
        SampleTwoRoutes.screen_one: Screen<String>(
          builder: ScreenOne.builder,
          wrapperFn: (screenContext, child) {
            return Provider<ScreenOneBloc>.value(
              value: ScreenOneBloc(),
              child: child,
            );
          },
        ),
        SampleTwoRoutes.screen_two:
            const Screen<String>(builder: ScreenTwo.builder),
      };

  @override
  WrapperFn get screensWrapper =>
      (ScreenContext screenContext, Widget screenWidget) {
        return Provider<SampleTwoBloc>.value(
          value: SampleTwoBloc(),
          child: screenWidget,
        );
      };

  static ScreenRoute screenOne(String testId) =>
      ScreenRoute(SampleTwoRoutes.screen_one, {'testId': testId});

  static ScreenRoute screenTwo() => ScreenRoute(SampleTwoRoutes.screen_two);
}

final sampleTwoNuvigator = Nuvigator(
  router: SampleTwoRouter(),
  initialRoute: SampleTwoRoutes.screen_one,
  screenType: cupertinoScreenType,
  wrapperFn: (ScreenContext screenContext, Widget child) =>
      Provider<SampleFlowBloc>.value(
    value: SampleFlowBloc(),
    child: child,
  ),
);
