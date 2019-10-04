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
        SampleTwoRoutes.screen_one: s2ScreenOnePage,
        SampleTwoRoutes.screen_two: s2ScreenTwoPage,
      };

  @override
  Widget screenWrapper(ScreenContext screenContext, Widget screenWidget) {
    return Provider<SampleTwoBloc>.value(
      value: SampleTwoBloc(),
      child: screenWidget,
    );
  }

  static ScreenRoute screenOne(String testId) =>
      ScreenRoute(SampleTwoRoutes.screen_one, {'testId': testId});

  static ScreenRoute screenTwo() => ScreenRoute(SampleTwoRoutes.screen_two);
}

final sampleTwoNuvigator = Nuvigator(
  router: SampleTwoRouter(),
  initialRoute: SampleTwoRoutes.screen_one,
  wrapperFn: (ScreenContext screenContext, Widget child) =>
      Provider<SampleFlowBloc>.value(
    value: SampleFlowBloc(),
    child: child,
  ),
);

//final sampleTwoRouter = FlowRouter(
//    baseRouter: SampleTwoRouter(),
//    flowWrapper: (ScreenContext screenContext, Widget child) =>
//        Provider<SampleFlowBloc>.value(
//          value: SampleFlowBloc(),
//          child: child,
//        ));
