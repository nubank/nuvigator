//import 'package:example/samples/modules/sample_one/navigation/sample_one_router.nuvigation.g.dart';
import 'package:example/samples/modules/sample_two/navigation/sample_two_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:nuvigator/builder.dart';
import 'package:nuvigator/nuvigator.dart';

import '../screen/screen_one.dart';
import '../screen/screen_two.dart';
import 'sample_one_routes.dart';

part 'sample_one_router.nuvigation.g.dart';

const screenOneDeepLink =
    'exapp://deepPrefix/sampleOne/screenOne/id_1234_deepLink';

class SampleOneRouter extends SimpleRouter {
  @override
  String get deepLinkPrefix => '/sampleOne/';

  @override
  Map<String, Screen> get screensMap => const {
        SampleOneRoutes.screen_one: Screen(
          builder: ScreenOne.builder,
          deepLink: 'screenOne/:testId',
        ),
        SampleOneRoutes.screen_two: Screen<int>(
          builder: ScreenTwo.builder,
        ),
      };

  static ScreenRoute screenOne(String testId) =>
      ScreenRoute(SampleOneRoutes.screen_one, {'testId': testId});

  static ScreenRoute screenTwo() => ScreenRoute(SampleOneRoutes.screen_two);
}

final sampleOneRouter = SampleOneRouter();

@nuRouter
class SimulationRouter extends SimpleRouter {
  @NuRoute(args: {'aaa': String})
  final Screen test = Screen();

  @override
  Map<String, Screen> get screensMap => simulationRouter$getScreensMap(this);
}

@nuRouter
class LendingRouter extends GroupRouter {
  @NuRoute(args: {'testId': String})
  final Screen paymentResume = Screen();

  @NuRoute(args: {'myParams': String})
  final Screen paymentSucceeded = Screen();

  @NuRoute(subRouter: SimulationRouter)
  final Screen paymentSimulations = Screen();

  @override
  Map<String, Screen> get screensMap => lendingRouter$getScreensMap(this);

  @override
  List<Router> get routers => lendingRouter$getSubRoutersList(this);
}

@nuRouter
class NuAppRouter extends GroupRouter {
  @nuSubRouter
  final LendingRouter lendingRouter = LendingRouter();

  @NuRoute()
  final Screen mgmNudge = Screen();

  @override
  Map<String, Screen> get screensMap => nuAppRouter$getScreensMap(this);

  @override
  List<Router> get routers => nuAppRouter$getSubRoutersList(this);
}
