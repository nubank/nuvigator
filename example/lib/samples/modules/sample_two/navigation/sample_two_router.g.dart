// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_two_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SampleTwoRoutes {
  static const screenOne = 'exapp://sampleTwo/screenOne';

  static const screenTwo = 'exapp://sampleTwo/screenTwo';
}

extension SampleTwoRouterNavigation on SampleTwoRouter {
  Future<Object> toScreenOne() {
    return nuvigator.pushNamed<Object>(
      SampleTwoRoutes.screenOne,
    );
  }

  Future<Object> pushReplacementToScreenOne<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<Object, TO>(
      SampleTwoRoutes.screenOne,
      result: result,
    );
  }

  Future<Object> pushAndRemoveUntilToScreenOne<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<Object>(
      SampleTwoRoutes.screenOne,
      predicate,
    );
  }

  Future<Object> popAndPushToScreenOne<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<Object, TO>(
      SampleTwoRoutes.screenOne,
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
  Map<String, ScreenRouteBuilder> get _$screensMap {
    return {
      SampleTwoRoutes.screenOne: (RouteSettings settings) {
        return screenOne();
      },
      SampleTwoRoutes.screenTwo: (RouteSettings settings) {
        return screenTwo();
      },
    };
  }
}
