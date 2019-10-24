// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'samples_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SamplesRoutes {
  static const home = 'samples/home';

  static const second = 'samples/second';
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
  SamplesNavigation get samplesNavigation => SamplesNavigation.of(context);
}

class SamplesNavigation {
  SamplesNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SamplesNavigation of(BuildContext context) =>
      SamplesNavigation(Nuvigator.of(context));
  Future<Object> toHome() {
    return nuvigator.pushNamed<Object>(
      SamplesRoutes.home,
    );
  }

  Future<Object> pushReplacementToHome<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<Object, TO>(
      SamplesRoutes.home,
      result: result,
    );
  }

  Future<Object> pushAndRemoveUntilToHome<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<Object>(
      SamplesRoutes.home,
      predicate,
    );
  }

  Future<Object> popAndPushToHome<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<Object, TO>(
      SamplesRoutes.home,
      result: result,
    );
  }

  Future<void> toSecond({String testId}) {
    return nuvigator.pushNamed<void>(
      SamplesRoutes.second,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<void> pushReplacementToSecond<TO extends Object>(
      {String testId, TO result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      SamplesRoutes.second,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToSecond<TO extends Object>(
      {String testId, @required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      SamplesRoutes.second,
      predicate,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<void> popAndPushToSecond<TO extends Object>(
      {String testId, TO result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      SamplesRoutes.second,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  SampleTwoNavigation get sampleTwoNavigation => SampleTwoNavigation(nuvigator);
  SampleOneNavigation get sampleOneNavigation => SampleOneNavigation(nuvigator);
}

Map<RouteDef, ScreenRouteBuilder> _$samplesScreensMap(SamplesRouter router) {
  return {
    RouteDef(SamplesRoutes.home): (RouteSettings settings) {
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
