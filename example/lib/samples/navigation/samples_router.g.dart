// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'samples_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SamplesRoutes {
  static const home = 'Samples/home';

  static const second = 'Samples/second';
}

class SecondArgs {
  SecondArgs({@required this.testId});

  final String testId;

  static SecondArgs parse(Map<String, Object> args) {
    return SecondArgs(
      testId: args['testId'],
    );
  }

  static SecondArgs of(BuildContext context) {
    final routeSettings = ModalRoute.of(context)?.settings;
    final nuvigator = Nuvigator.of(context);
    if (routeSettings?.name == SamplesRoutes.second) {
      final args = routeSettings?.arguments;
      if (args is SecondArgs) return args;
      if (args is Map<String, Object>) return parse(args);
    } else if (nuvigator != null) {
      return of(nuvigator.context);
    }
    return null;
  }
}

abstract class SecondScreen extends ScreenWidget {
  SecondScreen(BuildContext context) : super(context);

  SecondArgs get args => SecondArgs.of(context);
}

class SamplesNavigation {
  SamplesNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SamplesNavigation of(BuildContext context) =>
      SamplesNavigation(Nuvigator.of(context));
  Future<Object> home() {
    return nuvigator.pushNamed<Object>(SamplesRoutes.home);
  }

  Future<void> second({String testId}) {
    return nuvigator.pushNamed<void>(SamplesRoutes.second, arguments: {
      'testId': testId,
    });
  }

  SampleTwoNavigation get sampleTwoNavigation => SampleTwoNavigation(nuvigator);
  SampleOneNavigation get sampleOneNavigation => SampleOneNavigation(nuvigator);
}

Map<RouteDef, ScreenRouteBuilder> _$samplesScreensMap(SamplesRouter router) {
  return {
    RouteDef(SamplesRoutes.home): (RouteSettings settings) {
      final Map<String, Object> args = settings.arguments;
      return router.home();
    },
    RouteDef(SamplesRoutes.second): (RouteSettings settings) {
      final Map<String, Object> args = settings.arguments;
      return router.second(testId: args['testId']);
    },
  };
}

List<Router> _$samplesRoutersList(SamplesRouter router) => [
      router.sampleOneRouter,
    ];
