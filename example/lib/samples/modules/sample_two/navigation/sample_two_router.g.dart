// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_two_router.dart';

// **************************************************************************
// NuvigationGenerator
// **************************************************************************

class SampleTwoRouterRoutes {
  static const screenOne = 'SampleTwoRouter/screenOne';

  static const screenTwo = 'SampleTwoRouter/screenTwo';
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

class SampleTwoRouterNavigation {
  SampleTwoRouterNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SampleTwoRouterNavigation of(BuildContext context) =>
      SampleTwoRouterNavigation(Nuvigator.of(context));
  Future<String> screenOne({String testId}) {
    return nuvigator
        .pushNamed<String>(SampleTwoRouterRoutes.screenOne, arguments: {
      'testId': testId,
    });
  }

  Future<String> screenTwo() {
    return nuvigator.pushNamed<String>(SampleTwoRouterRoutes.screenTwo);
  }
}

Map<String, ScreenRoute> sampleTwoRouter$getScreensMap(SampleTwoRouter router) {
  return {
    SampleTwoRouterRoutes.screenOne: router.screenOne,
    SampleTwoRouterRoutes.screenTwo: router.screenTwo,
  };
}

List<Router> sampleTwoRouter$getSubRoutersList(SampleTwoRouter router) => [];
