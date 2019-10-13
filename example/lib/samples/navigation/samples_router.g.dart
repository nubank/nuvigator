// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'samples_router.dart';

// **************************************************************************
// NuvigationGenerator
// **************************************************************************

class SamplesRouterRoutes {
  static const home = 'SamplesRouter/home';

  static const second = 'SamplesRouter/second';
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
    final args = ModalRoute.of(context)?.settings?.arguments;
    if (args is SecondArgs) return args;
    if (args is Map<String, Object>) return parse(args);
    return null;
  }
}

class SamplesRouterNavigation {
  SamplesRouterNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SamplesRouterNavigation of(BuildContext context) =>
      SamplesRouterNavigation(Nuvigator.of(context));
  Future<Object> home() {
    return nuvigator.pushNamed<Object>(SamplesRouterRoutes.home);
  }

  Future<Object> second({String testId}) {
    return nuvigator.pushNamed<Object>(SamplesRouterRoutes.second, arguments: {
      'testId': testId,
    });
  }

  SampleTwoRouterNavigation get sampleTwoRouterNavigation =>
      SampleTwoRouterNavigation(nuvigator);
  SampleOneRouterNavigation get sampleOneRouterNavigation =>
      SampleOneRouterNavigation(nuvigator);
}

Map<String, ScreenRoute> samplesRouter$getScreensMap(SamplesRouter router) {
  return {
    SamplesRouterRoutes.home: router.home,
    SamplesRouterRoutes.second: router.second,
  };
}

List<Router> samplesRouter$getSubRoutersList(SamplesRouter router) => [
      router.sampleOneRouter,
    ];
