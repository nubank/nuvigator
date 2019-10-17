import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../bloc/sample_flow_bloc.dart';
import '../screen/screen_one.dart';
import '../screen/screen_two.dart';

part 'sample_two_router.g.dart';

@NuRouter()
class SampleTwoRouter extends BaseRouter {
  @NuRoute(args: {'testId': String})
  final screenOne = const ScreenRoute<String>(builder: ScreenOne.builder);

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
