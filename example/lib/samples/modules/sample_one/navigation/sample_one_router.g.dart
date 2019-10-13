// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_one_router.dart';

// **************************************************************************
// NuvigationGenerator
// **************************************************************************

class SampleOneRouterRoutes {
  static const screenOne = 'SampleOneRouter/screenOne';

  static const screenTwo = 'SampleOneRouter/screenTwo';
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

class SampleOneRouterNavigation {
  SampleOneRouterNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SampleOneRouterNavigation of(BuildContext context) =>
      SampleOneRouterNavigation(Nuvigator.of(context));
  Future<Object> screenOne({String testId}) {
    return nuvigator
        .pushNamed<Object>(SampleOneRouterRoutes.screenOne, arguments: {
      'testId': testId,
    });
  }

  Future<int> screenTwo() {
    return nuvigator.pushNamed<int>(SampleOneRouterRoutes.screenTwo);
  }
}

Map<String, ScreenRoute> sampleOneRouter$getScreensMap(SampleOneRouter router) {
  return {
    SampleOneRouterRoutes.screenOne: router.screenOne,
    SampleOneRouterRoutes.screenTwo: router.screenTwo,
  };
}

List<Router> sampleOneRouter$getSubRoutersList(SampleOneRouter router) => [];
