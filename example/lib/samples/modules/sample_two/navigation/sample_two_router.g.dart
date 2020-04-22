// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_two_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class _SampleTwoRoutes {
  static const screenOne = '/screenOne';

  static const screenTwo = '/screenTwo';
}

extension SampleTwoRouterNavigation on SampleTwoRouter {
  Future<Object> toScreenOne() {
    return nuvigator.pushNamed<Object>(
      pathWithPrefix(_SampleTwoRoutes.screenOne),
    );
  }

  Future<Object> pushReplacementToScreenOne<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<Object, TO>(
      pathWithPrefix(_SampleTwoRoutes.screenOne),
      result: result,
    );
  }

  Future<Object> pushAndRemoveUntilToScreenOne<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<Object>(
      pathWithPrefix(_SampleTwoRoutes.screenOne),
      predicate,
    );
  }

  Future<Object> popAndPushToScreenOne<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<Object, TO>(
      pathWithPrefix(_SampleTwoRoutes.screenOne),
      result: result,
    );
  }

  Future<String> toScreenTwo() {
    return nuvigator.pushNamed<String>(
      pathWithPrefix(_SampleTwoRoutes.screenTwo),
    );
  }

  Future<String> pushReplacementToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      pathWithPrefix(_SampleTwoRoutes.screenTwo),
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToScreenTwo<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      pathWithPrefix(_SampleTwoRoutes.screenTwo),
      predicate,
    );
  }

  Future<String> popAndPushToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
      pathWithPrefix(_SampleTwoRoutes.screenTwo),
      result: result,
    );
  }
}

extension SampleTwoRouterScreensAndRouters on SampleTwoRouter {
  Map<RoutePath, ScreenRouteBuilder> get _$screensMap {
    return {
      RoutePath(_SampleTwoRoutes.screenOne, prefix: false):
          (RouteSettings settings) {
        return screenOne();
      },
      RoutePath(_SampleTwoRoutes.screenTwo, prefix: false):
          (RouteSettings settings) {
        return screenTwo();
      },
    };
  }
}
