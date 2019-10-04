import 'package:example/samples/modules/sample_one/navigation/sample_one_routes.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../bloc/samples_bloc.dart';
import '../modules/sample_one/navigation/sample_one_router.dart';
import '../modules/sample_two/navigation/sample_two_router.dart';

class _SamplesRouter extends GroupRouter {
  @override
  String get deepLinkPrefix => 'deepprefix';

  @override
  Map<String, Screen> get screensMap => {
        'home': Screen.material((screenContext) => HomeScreen(screenContext)),
        'second': Screen.cupertinoDialog<String>(
            NuvigatorScreen.fromScreenContext(
                router: sampleOneRouter,
                initialRoute: SampleOneRoutes.screen_one))
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
