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
    final routeSettings = ModalRoute.of(context)?.settings;
    final nuvigator = Nuvigator.of(context);
    if (routeSettings?.name == SampleTwoRoutes.screenOne) {
      final args = routeSettings?.arguments;
      if (args is ScreenOneArgs) return args;
      if (args is Map<String, Object>) return parse(args);
    } else if (nuvigator != null) {
      return of(nuvigator.context);
    }
    return null;
  }
}

abstract class ScreenOneScreen extends ScreenWidget {
  ScreenOneScreen(BuildContext context) : super(context);

  ScreenOneArgs get args => ScreenOneArgs.of(context);
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

Map<RouteDef, ScreenRouteBuilder> _$sampleTwoScreensMap(
    SampleTwoRouter router) {
  return {
    RouteDef(SampleTwoRoutes.screenOne): (RouteSettings settings) {
      final Map<String, Object> args = settings.arguments;
      return router.screenOne(testId: args['testId']);
    },
    RouteDef(SampleTwoRoutes.screenTwo): (RouteSettings settings) {
      final Map<String, Object> args = settings.arguments;
      return router.screenTwo();
    },
  };
}

List<Router> _$sampleTwoRoutersList(SampleTwoRouter router) => [];
