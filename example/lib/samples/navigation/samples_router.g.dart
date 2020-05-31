// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'samples_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SamplesRoutes {
  static const home = 'exapp://home';

  static const second = 'exapp://sampleTwo';
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
  String homeDeepLink() =>
      encodeDeepLink(pathWithPrefix(SamplesRoutes.home), <String, dynamic>{});
  Future<void> toHome() {
    return nuvigator.pushNamed<void>(
      pathWithPrefix(SamplesRoutes.home),
    );
  }

  Future<void> pushReplacementToHome<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      pathWithPrefix(SamplesRoutes.home),
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToHome<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      pathWithPrefix(SamplesRoutes.home),
      predicate,
    );
  }

  Future<void> popAndPushToHome<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      pathWithPrefix(SamplesRoutes.home),
      result: result,
    );
  }

  String secondDeepLink({@required String testId, @required String path}) =>
      encodeDeepLink(
          pathWithPrefix(SamplesRoutes.second) + path, <String, dynamic>{
        'testId': testId,
      });
  Future<String> toSecond({@required String testId, @required String path}) {
    return nuvigator.pushNamed<String>(
      pathWithPrefix(SamplesRoutes.second) + path,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> pushReplacementToSecond<TO extends Object>(
      {@required String testId, @required String path, TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      pathWithPrefix(SamplesRoutes.second) + path,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToSecond<TO extends Object>(
      {@required String testId,
      @required String path,
      @required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      pathWithPrefix(SamplesRoutes.second) + path,
      predicate,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> popAndPushToSecond<TO extends Object>(
      {@required String testId, @required String path, TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
      pathWithPrefix(SamplesRoutes.second) + path,
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
  Map<RoutePath, ScreenRouteBuilder> get _$screensMap {
    return {
      RoutePath(SamplesRoutes.home, prefix: false): (RouteSettings settings) {
        return home();
      },
      RoutePath(SamplesRoutes.second, prefix: true): (RouteSettings settings) {
        final Map<String, Object> args = settings.arguments ?? const {};
        return second(testId: args['testId']);
      },
    };
  }
}
