// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_one_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SampleOneRoutes {
  static const screenOne = 'exapp://sampleOne/screenOne/:testId';

  static const screenTwo = 'exapp://sampleOne/screenTwo';
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
    if (routeSettings?.name == SampleOneRoutes.screenOne) {
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
      SampleOneRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> pushReplacementToScreenOne<TO extends Object>(
      {@required String testId, TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      SampleOneRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToScreenOne<TO extends Object>(
      {@required String testId, @required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      SampleOneRoutes.screenOne,
      predicate,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> popAndPushToScreenOne<TO extends Object>(
      {@required String testId, TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
      SampleOneRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<int> toScreenTwo() {
    return nuvigator.pushNamed<int>(
      SampleOneRoutes.screenTwo,
    );
  }

  Future<int> pushReplacementToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<int, TO>(
      SampleOneRoutes.screenTwo,
      result: result,
    );
  }

  Future<int> pushAndRemoveUntilToScreenTwo<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<int>(
      SampleOneRoutes.screenTwo,
      predicate,
    );
  }

  Future<int> popAndPushToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<int, TO>(
      SampleOneRoutes.screenTwo,
      result: result,
    );
  }
}

extension SampleOneRouterScreensAndRouters on SampleOneRouter {
  Map<String, ScreenRouteBuilder> get _$screensMap {
    return {
      SampleOneRoutes.screenOne: (RouteSettings settings) {
        final Map<String, Object> args = settings.arguments ?? const {};
        return screenOne(testId: args['testId']);
      },
      SampleOneRoutes.screenTwo: (RouteSettings settings) {
        return screenTwo();
      },
    };
  }
}
