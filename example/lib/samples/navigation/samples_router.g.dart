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
    final args = ModalRoute.of(context)?.settings?.arguments;
    if (args is SecondArgs) return args;
    if (args is Map<String, Object>) return parse(args);
    return null;
  }
}

class SamplesNavigation {
  SamplesNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SamplesNavigation of(BuildContext context) =>
      SamplesNavigation(Nuvigator.of(context));
  Future<Object> home() {
    return nuvigator.pushNamed<Object>(SamplesRoutes.home);
  }

  Future<Object> second({String testId}) {
    return nuvigator.pushNamed<Object>(SamplesRoutes.second, arguments: {
      'testId': testId,
    });
  }

  SampleTwoNavigation get sampleTwoNavigation => SampleTwoNavigation(nuvigator);
  SampleOneNavigation get sampleOneNavigation => SampleOneNavigation(nuvigator);
}

Map<String, ScreenRoute> _$samplesScreensMap(SamplesRouter router) {
  return {
    SamplesRoutes.home: router.home,
    SamplesRoutes.second: router.second,
  };
}

List<Router> _$samplesRoutersList(SamplesRouter router) => [
      router.sampleOneRouter,
    ];
