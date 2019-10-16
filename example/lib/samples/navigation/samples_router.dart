import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../bloc/samples_bloc.dart';
import '../modules/sample_one/navigation/sample_one_router.dart';
import '../modules/sample_two/navigation/sample_two_router.dart';

part 'samples_router.g.dart';

@NuRouter()
class SamplesRouter extends BaseRouter {
  @override
  String get deepLinkPrefix => 'deepprefix';

  @override
  WrapperFn get screensWrapper => (BuildContext context, Widget child) {
        return Provider<SamplesBloc>.value(
          value: SamplesBloc(),
          child: child,
        );
      };

  @NuRoute()
  final home = ScreenRoute(
    builder: (context) => HomeScreen(context),
  );

  @NuRoute(args: {'testId': String})
  final second = FlowRoute(
    nuvigator: sampleTwoNuvigator,
  );

  @NuRouter()
  final sampleOneRouter = SampleOneRouter();

  @override
  Map<String, ScreenRoute> get screensMap => _$samplesScreensMap(this);

  @override
  List<Router> get routers => _$samplesRoutersList(this);
}

final samplesRouter = SamplesRouter();
