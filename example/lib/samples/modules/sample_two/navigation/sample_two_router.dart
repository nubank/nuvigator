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

//  static void screenOneS2Args(String testId) {}
  @NuRoute()
  ScreenRoute<String> screenOne({String testId}) => const ScreenRoute(
        builder: ScreenOne.builder,
//        wrapper: (screenContext, child) {
//          return Provider<ScreenOneBloc>.value(
//            value: ScreenOneBloc(),
//            child: child,
//          );
//        },
      );

  @NuRoute(pushMethods: [PushMethodType.push, PushMethodType.pushReplacement])
  ScreenRoute<String> screenTwo() =>
      const ScreenRoute<String>(builder: ScreenTwo.builder);

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap =>
      _$sampleTwoScreensMap(this);
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
