// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'samples_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SamplesRoutes {
  static const home = 'exapp://home';

  static const second = 'exapp://sampleTwo*';
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
  Future<void> toHome() {
    return nuvigator.pushNamed<void>(
      SamplesRoutes.home,
    );
  }

  Future<void> pushReplacementToHome<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      SamplesRoutes.home,
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToHome<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      SamplesRoutes.home,
      predicate,
    );
  }

  Future<void> popAndPushToHome<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      SamplesRoutes.home,
      result: result,
    );
  }

  Future<String> toSecond({@required String testId}) {
    return nuvigator.pushNamed<String>(
      SamplesRoutes.second,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> pushReplacementToSecond<TO extends Object>(
      {@required String testId, TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      SamplesRoutes.second,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToSecond<TO extends Object>(
      {@required String testId, @required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      SamplesRoutes.second,
      predicate,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> popAndPushToSecond<TO extends Object>(
      {@required String testId, TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
      SamplesRoutes.second,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  SampleOneRouter get sampleOneRouter => getRouter<SampleOneRouter>();
}

extension SamplesRouterScreensAndRouters on SamplesRouter {
  List<Router> get _$routers => [
        sampleOneRouter,
      ];
  Map<String, ScreenRouteBuilder> get _$screensMap {
    return {
      SamplesRoutes.home: (RouteSettings settings) {
        return home();
      },
      SamplesRoutes.second: (RouteSettings settings) {
        final Map<String, Object> args = settings.arguments ?? const {};
        return second(testId: args['testId']);
      },
    };
  }
}
