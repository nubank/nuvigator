import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routing/routing.dart';

import '../../main.dart';
import '../../src/example_app_router.dart';
import '../bloc/samples_bloc.dart';
import '../modules/sample_one/navigation/sample_one_router.dart';
import '../modules/sample_two/navigation/sample_two_router.dart';

class _SamplesRouter extends GroupRouter {
  @override
  String get deepLinkPrefix => 'deepprefix';

  @override
  Map<String, Screen> get screensMap => {
        'home': NuScreen.page((screenContext) => HomeScreen(screenContext)),
      };

  @override
  List<Router> get routers => [
        sampleOneRouter,
        sampleTwoRouter,
      ];

  @override
  Widget screenWrapper(ScreenContext screenContext, Widget screenWidget) {
    return Provider<SamplesBloc>.value(
      value: SamplesBloc(),
      child: screenWidget,
    );
  }
}

final samplesRouter = _SamplesRouter();
