// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class FriendRequestRoutes {
  static const listRequests = 'listRequests';

  static const success = 'success';
}

extension FriendRequestRouterNavigation on FriendRequestRouter {
  String listRequestsDeepLink() => encodeDeepLink(
      pathWithPrefix(FriendRequestRoutes.listRequests), <String, dynamic>{});
  Future<void> toListRequests() {
    return nuvigator.pushNamed<void>(
      pathWithPrefix(FriendRequestRoutes.listRequests),
    );
  }

  Future<void> pushReplacementToListRequests<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      pathWithPrefix(FriendRequestRoutes.listRequests),
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToListRequests<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      pathWithPrefix(FriendRequestRoutes.listRequests),
      predicate,
    );
  }

  Future<void> popAndPushToListRequests<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      pathWithPrefix(FriendRequestRoutes.listRequests),
      result: result,
    );
  }

  String successDeepLink() => encodeDeepLink(
      pathWithPrefix(FriendRequestRoutes.success), <String, dynamic>{});
  Future<void> toSuccess() {
    return nuvigator.pushNamed<void>(
      pathWithPrefix(FriendRequestRoutes.success),
    );
  }

  Future<void> pushReplacementToSuccess<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      pathWithPrefix(FriendRequestRoutes.success),
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToSuccess<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      pathWithPrefix(FriendRequestRoutes.success),
      predicate,
    );
  }

  Future<void> popAndPushToSuccess<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      pathWithPrefix(FriendRequestRoutes.success),
      result: result,
    );
  }
}

extension FriendRequestRouterScreensAndRouters on FriendRequestRouter {
  Map<RoutePath, ScreenRouteBuilder> get _$screensMap {
    return {
      RoutePath(FriendRequestRoutes.listRequests, prefix: false):
          (RouteSettings settings) {
        return listRequests();
      },
      RoutePath(FriendRequestRoutes.success, prefix: false):
          (RouteSettings settings) {
        return success();
      },
    };
  }
}
