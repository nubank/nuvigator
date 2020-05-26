// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_one_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class _SampleOneRoutes {
  static const screenOne = '/screenOne/:testId';

  static const screenTwo = '/screenTwo';
}

class ScreenOneArgs {
  ScreenOneArgs({@required this.testId});

  final String testId;

  static ScreenOneArgs parse(Map<String, Object> args) {
    return ScreenOneArgs(
      testId: args['testId'],
    );
  }

  Map<String, Object> get toMap => {
        'testId': testId,
      };
  static ScreenOneArgs of(BuildContext context) {
    final routeSettings = ModalRoute.of(context)?.settings;
    final nuvigator = Nuvigator.of(context);
    if (routeSettings?.name == _SampleOneRoutes.screenOne) {
      final args = routeSettings?.arguments;
      if (args == null)
        throw FlutterError('ScreenOneArgs requires Route arguments');
      if (args is ScreenOneArgs) return args;
      if (args is Map<String, Object>) return parse(args);
    } else if (nuvigator != null) {
      return of(nuvigator.context);
    }
    return null;
  }
}

extension SampleOneRouterNavigation on SampleOneRouter {
  Future<String> toScreenOne({@required String testId}) {
    return nuvigator.pushNamed<String>(
      pathWithPrefix(_SampleOneRoutes.screenOne),
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> pushReplacementToScreenOne<TO extends Object>(
      {@required String testId, TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      pathWithPrefix(_SampleOneRoutes.screenOne),
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToScreenOne<TO extends Object>(
      {@required String testId, @required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      pathWithPrefix(_SampleOneRoutes.screenOne),
      predicate,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> popAndPushToScreenOne<TO extends Object>(
      {@required String testId, TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
      pathWithPrefix(_SampleOneRoutes.screenOne),
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  String screenOneDeepLink({@required String testId}) => encodeDeepLink(
          pathWithPrefix(_SampleOneRoutes.screenOne), <String, dynamic>{
        'testId': testId,
      });
  Future<int> toScreenTwo() {
    return nuvigator.pushNamed<int>(
      pathWithPrefix(_SampleOneRoutes.screenTwo),
    );
  }

  Future<int> pushReplacementToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<int, TO>(
      pathWithPrefix(_SampleOneRoutes.screenTwo),
      result: result,
    );
  }

  Future<int> pushAndRemoveUntilToScreenTwo<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<int>(
      pathWithPrefix(_SampleOneRoutes.screenTwo),
      predicate,
    );
  }

  Future<int> popAndPushToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<int, TO>(
      pathWithPrefix(_SampleOneRoutes.screenTwo),
      result: result,
    );
  }

  String screenTwoDeepLink() => encodeDeepLink(
      pathWithPrefix(_SampleOneRoutes.screenTwo), <String, dynamic>{});
}

extension SampleOneRouterScreensAndRouters on SampleOneRouter {
  Map<RoutePath, ScreenRouteBuilder> get _$screensMap {
    return {
      RoutePath(_SampleOneRoutes.screenOne, prefix: false):
          (RouteSettings settings) {
        final Map<String, Object> args = settings.arguments ?? const {};
        return screenOne(testId: args['testId']);
      },
      RoutePath(_SampleOneRoutes.screenTwo, prefix: false):
          (RouteSettings settings) {
        return screenTwo();
      },
    };
  }
}
