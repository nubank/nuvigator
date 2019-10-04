import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../bloc/samples_bloc.dart';
import '../modules/sample_one/navigation/sample_one_router.dart';
import '../modules/sample_two/navigation/sample_two_router.dart';

class SamplesRouter extends GroupRouter {
  @override
  String get deepLinkPrefix => 'deepprefix';

  @override
  Map<String, Screen> get screensMap => {
        'home': Screen(
          builder: (screenContext) => HomeScreen(screenContext),
        ),
        'second': Screen(
          builder: sampleTwoNuvigator,
        ),
      };

  @override
  List<Router> get routers => [
        sampleOneRouter,
      ];

  @override
  WrapperFn get screensWrapper => (ScreenContext screenContext, Widget child) {
        return Provider<SamplesBloc>.value(
          value: SamplesBloc(),
          child: child,
        );
      };

  // Navigation Helpers

  static ScreenRoute sampleTwo(String testId) {
    return ScreenRoute('second', {'testId': testId});
  }
}

final samplesRouter = SamplesRouter();
