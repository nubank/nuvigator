// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class FriendRequestRoutes {
  static const listRequests = 'friendRequest/listRequests';

  static const success = 'friendRequest/success';
}

extension FriendRequestRouterNavigation on OldFriendRequestRouter {
  Future<void> toListRequests() {
    return nuvigator.pushNamed<void>(
      FriendRequestRoutes.listRequests,
    );
  }

  Future<void> pushReplacementToListRequests<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      FriendRequestRoutes.listRequests,
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToListRequests<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      FriendRequestRoutes.listRequests,
      predicate,
    );
  }

  Future<void> popAndPushToListRequests<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      FriendRequestRoutes.listRequests,
      result: result,
    );
  }

  Future<void> toSuccess() {
    return nuvigator.pushNamed<void>(
      FriendRequestRoutes.success,
    );
  }

  Future<void> pushReplacementToSuccess<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      FriendRequestRoutes.success,
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToSuccess<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      FriendRequestRoutes.success,
      predicate,
    );
  }

  Future<void> popAndPushToSuccess<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      FriendRequestRoutes.success,
      result: result,
    );
  }
}

extension FriendRequestRouterScreensAndRouters on OldFriendRequestRouter {
  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(FriendRequestRoutes.listRequests,
          deepLink: 'old-friend-request/list'): (RouteSettings settings) {
        return listRequests();
      },
      RouteDef(FriendRequestRoutes.success,
          deepLink: 'old-friend-request/success'): (RouteSettings settings) {
        return success();
      },
    };
  }
}
