// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_one_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SampleOneRoutes {
  static const screenOne = 'sampleOne/screenOne';

  static const screenTwo = 'sampleOne/screenTwo';
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
    if (routeSettings?.name == SampleOneRoutes.screenOne) {
      final args = routeSettings?.arguments;
      if (args is ScreenOneArgs) return args;
      if (args is Map<String, Object>) return parse(args);
    } else if (nuvigator != null) {
      return of(nuvigator.context);
    }
    return null;
  }
}

extension SampleOneRouterNavigation on SampleOneRouter {
  Future<Object> toScreenOne({@required String testId}) {
    return nuvigator.pushNamed<Object>(
      SampleOneRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<Object> pushReplacementToScreenOne<TO extends Object>(
      {@required String testId, TO result}) {
    return nuvigator.pushReplacementNamed<Object, TO>(
      SampleOneRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<Object> pushAndRemoveUntilToScreenOne<TO extends Object>(
      {@required String testId, @required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<Object>(
      SampleOneRoutes.screenOne,
      predicate,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<Object> popAndPushToScreenOne<TO extends Object>(
      {@required String testId, TO result}) {
    return nuvigator.popAndPushNamed<Object, TO>(
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
  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(SampleOneRoutes.screenOne, deepLink: '/screenOne/:testId'):
          (RouteSettings settings) {
        final Map<String, Object> args = settings.arguments;
        return screenOne(testId: args['testId']);
      },
      RouteDef(SampleOneRoutes.screenTwo): (RouteSettings settings) {
        return screenTwo();
      },
    };
  }
}
