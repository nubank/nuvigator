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

  Map<String, Object> get toMap => {
        'testId': testId,
      };

  static SecondArgs of(BuildContext context) {
    final routeSettings = ModalRoute.of(context)?.settings;
    final nuvigator = Nuvigator.of(context);
    if (routeSettings?.name == SamplesRoutes.second) {
      final args = routeSettings?.arguments;
      if (args == null)
        throw FlutterError('SecondArgs requires Route arguments');
      if (args is SecondArgs) return args;
      if (args is Map<String, Object>) return parse(args);
    } else if (nuvigator != null) {
      return of(nuvigator.context);
    }
    return null;
  }
}

extension SamplesRouterNavigation on SamplesRouter {
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

  SampleTwoRouter get sampleTwoRouter => getRouter<SampleTwoRouter>();

  SampleOneRouter get sampleOneRouter => getRouter<SampleOneRouter>();
}

extension SamplesRouterScreensAndRouters on SamplesRouter {
  List<Router> get _$routers => [
        sampleOneRouter,
      ];

  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(SamplesRoutes.home): (RouteSettings settings) {
        return home();
      },
      RouteDef(SamplesRoutes.second): (RouteSettings settings) {
        final Map<String, Object> args = settings.arguments;
        return second(testId: args['testId']);
      },
    };
  }
}
