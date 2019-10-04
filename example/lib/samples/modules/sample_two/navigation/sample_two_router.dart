import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../bloc/sample_flow_bloc.dart';
import '../bloc/sample_two_bloc.dart';
import '../screen/screen_one.dart';
import '../screen/screen_two.dart';
import 'sample_two_routes.dart';

class _SampleTwoRouter extends SimpleRouter {
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
}

final sampleTwoRouter = FlowRouter(
    baseRouter: _SampleTwoRouter(),
    flowWrapper: (ScreenContext screenContext, Widget child) =>
        Provider<SampleFlowBloc>.value(
          value: SampleFlowBloc(),
          child: child,
        ));
