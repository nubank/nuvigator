import 'package:example/samples/modules/sample_two/bloc/sample_flow_bloc.dart';
import 'package:example/samples/modules/sample_two/navigation/sample_two_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../bloc/samples_bloc.dart';
import '../modules/sample_one/navigation/sample_one_router.dart';

part 'samples_router.g.dart';

@NuRouter()
class SamplesRouter extends Router {
  @NuRoute(deepLink: 'home')
  ScreenRoute<void> home() => ScreenRoute(
        builder: (context) => HomeScreen(),
      );

  @NuRoute(deepLink: 'sampleTwo', prefix: true)
  ScreenRoute<String> second({@required String testId}) => ScreenRoute(
        screenType: cupertinoDialogScreenType,
        builder: Nuvigator(
          router: SampleTwoRouter(testId: testId),
          screenType: cupertinoScreenType,
          wrapper: (BuildContext context, Widget child) => Provider(
            create: (_) => SampleFlowBloc(),
            child: child,
          ),
        ),
      );

  @NuRouter()
  final SampleOneRouter sampleOneRouter = SampleOneRouter();

  @override
  WrapperFn get screensWrapper => (BuildContext context, Widget child) {
        return ChangeNotifierProvider<SamplesBloc>.value(
          value: SamplesBloc(),
          child: child,
        );
      };

  @override
  Map<RoutePath, ScreenRouteBuilder> get screensMap => _$screensMap;

  @override
  List<Router> get routers => _$routers;
}
