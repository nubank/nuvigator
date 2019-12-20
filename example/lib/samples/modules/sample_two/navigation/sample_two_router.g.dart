// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_two_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SampleTwoRoutes {
  static const screenOne = 'sampleTwo/screenOne';

  static const screenTwo = 'sampleTwo/screenTwo';
}

extension SampleTwoRouterNavigation on SampleTwoRouter {
  Future<String> toScreenOne() {
    return nuvigator.pushNamed<String>(
      SampleTwoRoutes.screenOne,
    );
  }

  Future<String> pushReplacementToScreenOne<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      SampleTwoRoutes.screenOne,
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToScreenOne<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      SampleTwoRoutes.screenOne,
      predicate,
    );
  }

  Future<String> popAndPushToScreenOne<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
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
  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(SampleTwoRoutes.screenOne): (RouteSettings settings) {
        return screenOne();
      },
      RouteDef(SampleTwoRoutes.screenTwo): (RouteSettings settings) {
        return screenTwo();
      },
    };
  }
}
