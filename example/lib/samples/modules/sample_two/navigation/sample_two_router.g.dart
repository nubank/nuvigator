// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_two_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SampleTwoRoutes {
  static const screenOne = '/screenOne';

  static const screenTwo = '/screenTwo';
}

extension SampleTwoRouterNavigation on SampleTwoRouter {
  String screenOneDeepLink() => encodeDeepLink(
      pathWithPrefix(SampleTwoRoutes.screenOne), <String, dynamic>{});
  Future<Object> toScreenOne() {
    return nuvigator.pushNamed<Object>(
      pathWithPrefix(SampleTwoRoutes.screenOne),
    );
  }

  Future<Object> pushReplacementToScreenOne<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<Object, TO>(
      pathWithPrefix(SampleTwoRoutes.screenOne),
      result: result,
    );
  }

  Future<Object> pushAndRemoveUntilToScreenOne<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<Object>(
      pathWithPrefix(SampleTwoRoutes.screenOne),
      predicate,
    );
  }

  Future<Object> popAndPushToScreenOne<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<Object, TO>(
      pathWithPrefix(SampleTwoRoutes.screenOne),
      result: result,
    );
  }

  String screenTwoDeepLink() => encodeDeepLink(
      pathWithPrefix(SampleTwoRoutes.screenTwo), <String, dynamic>{});
  Future<String> toScreenTwo() {
    return nuvigator.pushNamed<String>(
      pathWithPrefix(SampleTwoRoutes.screenTwo),
    );
  }

  Future<String> pushReplacementToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      pathWithPrefix(SampleTwoRoutes.screenTwo),
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToScreenTwo<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      pathWithPrefix(SampleTwoRoutes.screenTwo),
      predicate,
    );
  }

  Future<String> popAndPushToScreenTwo<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
      pathWithPrefix(SampleTwoRoutes.screenTwo),
      result: result,
    );
  }
}

extension SampleTwoRouterScreensAndRouters on SampleTwoRouter {
  Map<RoutePath, ScreenRouteBuilder> get _$screensMap {
    return {
      RoutePath(SampleTwoRoutes.screenOne, prefix: false):
          (RouteSettings settings) {
        return screenOne();
      },
      RoutePath(SampleTwoRoutes.screenTwo, prefix: false):
          (RouteSettings settings) {
        return screenTwo();
      },
    };
  }
}
