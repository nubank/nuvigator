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

  static void screenOneS2Args(String testId) {}
  @NuRoute(args: screenOneS2Args)
  final screenOne = ScreenRoute<String>(
    builder: ScreenOne.builder,
    wrapper: (screenContext, child) {
      return Provider<ScreenOneBloc>.value(
        value: ScreenOneBloc(),
        child: child,
      );
    },
  );

  @NuRoute()
  final screenTwo = const ScreenRoute<String>(builder: ScreenTwo.builder);

  @override
  Map<String, ScreenRoute> get screensMap => _$sampleTwoScreensMap(this);
}

final sampleTwoNuvigator = Nuvigator<SampleTwoRouter>(
  router: SampleTwoRouter(),
  initialRoute: SampleTwoRoutes.screenOne,
  screenType: cupertinoScreenType,
  wrapper: (BuildContext context, Widget child) => Provider<SampleFlowBloc>(
    builder: (_) => SampleFlowBloc(),
    child: child,
  ),
);
