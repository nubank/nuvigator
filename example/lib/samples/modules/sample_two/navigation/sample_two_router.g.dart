// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_two_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SampleTwoRoutes {
  static const screenOne = 'SampleTwo/screenOne';

  static const screenTwo = 'SampleTwo/screenTwo';
}

class ScreenOneArgs {
  ScreenOneArgs({@required this.testId});

  final String testId;

  static ScreenOneArgs parse(Map<String, Object> args) {
    return ScreenOneArgs(
      testId: args['testId'],
    );
  }

  static ScreenOneArgs of(BuildContext context) {
    final args = ModalRoute.of(context)?.settings?.arguments;
    if (args is ScreenOneArgs) return args;
    if (args is Map<String, Object>) return parse(args);
    return null;
  }
}

class SampleTwoNavigation {
  SampleTwoNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SampleTwoNavigation of(BuildContext context) =>
      SampleTwoNavigation(Nuvigator.of(context));
  Future<String> screenOne({String testId}) {
    return nuvigator.pushNamed<String>(SampleTwoRoutes.screenOne, arguments: {
      'testId': testId,
    });
  }

  Future<String> screenTwo() {
    return nuvigator.pushNamed<String>(SampleTwoRoutes.screenTwo);
  }
}

Map<String, ScreenRoute> _$sampleTwoScreensMap(SampleTwoRouter router) {
  return {
    SampleTwoRoutes.screenOne: router.screenOne,
    SampleTwoRoutes.screenTwo: router.screenTwo,
  };
}

List<Router> _$sampleTwoRoutersList(SampleTwoRouter router) => [];
