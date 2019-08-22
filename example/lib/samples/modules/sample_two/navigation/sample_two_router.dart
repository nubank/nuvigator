import 'package:example/samples/modules/sample_two/bloc/sample_flow_bloc.dart';
import 'package:example/samples/modules/sample_two/bloc/sample_two_bloc.dart';
import 'package:example/samples/modules/sample_two/screen/screen_two.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routing/routing.dart';

import '../screen/screen_one.dart';
import 'sample_two_routes.dart';

class _SampleTwoRouter extends SimpleRouter with FlowRouter<String> {
  @override
  Map<String, Screen> get screensMap => {
        SampleTwoRoutes.screen_one: s2ScreenOnePage,
        SampleTwoRoutes.screen_two: S2ScreenTwoPage,
      };

  @override
  String get initialRouteName => SampleTwoRoutes.screen_one;

  @override
  Widget screenWrapper(ScreenContext screenContext, Widget screenWidget) {
    return Provider<SampleTwoBloc>.value(
      value: SampleTwoBloc(),
      child: screenWidget,
    );
  }

  @override
  Widget flowWrapper(ScreenContext screenContext, Widget screenWidget) {
    return Provider<SampleFlowBloc>.value(
      value: SampleFlowBloc(),
      child: screenWidget,
    );
  }
}

final sampleTwoRouter = _SampleTwoRouter();
