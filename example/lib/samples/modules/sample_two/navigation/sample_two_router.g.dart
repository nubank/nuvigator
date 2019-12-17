// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_two_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SampleTwoRoutes {
  static const screenOne = 'sampleTwo/screenOne';

  static const screenTwo = 'sampleTwo/screenTwo';
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
    if (routeSettings?.name == SampleTwoRoutes.screenOne) {
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

extension SampleTwoRouterNavigation on SampleTwoRouter {
  Future<String> toScreenOne({String testId}) {
    return nuvigator.pushNamed<String>(
      SampleTwoRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> pushReplacementToScreenOne<TO extends Object>(
      {String testId, TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      SampleTwoRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToScreenOne<TO extends Object>(
      {String testId, @required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      SampleTwoRoutes.screenOne,
      predicate,
      arguments: {
        'testId': testId,
      },
    );
  }

  Future<String> popAndPushToScreenOne<TO extends Object>(
      {String testId, TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
      SampleTwoRoutes.screenOne,
      arguments: {
        'testId': testId,
      },
      result: result,
    );
  }

  Future<String> toScreenTwo() {
    return nuvigator.pushNamed<String>(
      SampleTwoRoutes.screenTwo,
    );
  }

  Future<String> pushReplacementToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      SampleTwoRoutes.screenTwo,
      result: result,
    );
  }
}

extension SampleTwoRouterScreensAndRouters on SampleTwoRouter {
  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(SampleTwoRoutes.screenOne): (RouteSettings settings) {
        final Map<String, Object> args = settings.arguments;
        return screenOne(testId: args['testId']);
      },
      RouteDef(SampleTwoRoutes.screenTwo): (RouteSettings settings) {
        return screenTwo();
      },
    };
  }
}
