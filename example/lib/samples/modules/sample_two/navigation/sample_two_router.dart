import 'package:example/samples/modules/sample_two/bloc/screen_one_bloc.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../bloc/sample_flow_bloc.dart';
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

  @NuRoute(args: {'testId': String})
  final screenOne = ScreenRoute<String>(
    builder: ScreenOne.builder,
    wrapperFn: (screenContext, child) {
      return Provider<ScreenOneBloc>.value(
        value: ScreenOneBloc(),
        child: child,
      );
    },
  );

  @NuRoute()
  final screenTwo = const ScreenRoute<String>(builder: ScreenTwo.builder);

  @override
  Map<String, ScreenRoute<Object>> get screensMap =>
      sampleTwoRouter$getScreensMap(this);
}

final sampleTwoNuvigator = Nuvigator<SampleTwoRouter>(
    router: SampleTwoRouter(),
    initialRoute: SampleTwoRouterRoutes.screenOne,
    screenType: cupertinoScreenType,
    wrapperFn: (BuildContext context, Widget child) =>
        Provider<SampleFlowBloc>.value(
          value: SampleFlowBloc(),
          child: child,
        ));
