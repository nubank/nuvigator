// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_one_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SampleOneRoutes {
  static const screenOne = 'SampleOne/screenOne';

  static const screenTwo = 'SampleOne/screenTwo';
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

class SampleOneNavigation {
  SampleOneNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SampleOneNavigation of(BuildContext context) =>
      SampleOneNavigation(Nuvigator.of(context));
  Future<Object> screenOne({String testId}) {
    return nuvigator.pushNamed<Object>(SampleOneRoutes.screenOne, arguments: {
      'testId': testId,
    });
  }

  Future<int> screenTwo() {
    return nuvigator.pushNamed<int>(SampleOneRoutes.screenTwo);
  }
}

Map<String, ScreenRoute> _$sampleOneScreensMap(SampleOneRouter router) {
  return {
    SampleOneRoutes.screenOne: router.screenOne,
    SampleOneRoutes.screenTwo: router.screenTwo,
  };
}

List<Router> _$sampleOneRoutersList(SampleOneRouter router) => [];
