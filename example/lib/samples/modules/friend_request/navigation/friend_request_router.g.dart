// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class OldFriendRequestRoutes {
  static const listRequests = 'oldFriendRequest/listRequests';

  static const success = 'oldFriendRequest/success';
}

extension OldFriendRequestRouterNavigation on OldFriendRequestRouter {
  Future<void> toListRequests() {
    return nuvigator.pushNamed<void>(
      OldFriendRequestRoutes.listRequests,
    );
  }

  Future<void> pushReplacementToListRequests<TO extends Object>({TO? result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      OldFriendRequestRoutes.listRequests,
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToListRequests<TO extends Object>(
      {required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      OldFriendRequestRoutes.listRequests,
      predicate,
    );
  }

  Future<void> popAndPushToListRequests<TO extends Object>({TO? result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      OldFriendRequestRoutes.listRequests,
      result: result,
    );
  }

  Future<void> toSuccess() {
    return nuvigator.pushNamed<void>(
      OldFriendRequestRoutes.success,
    );
  }

  Future<void> pushReplacementToSuccess<TO extends Object>({TO? result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      OldFriendRequestRoutes.success,
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToSuccess<TO extends Object>(
      {required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      OldFriendRequestRoutes.success,
      predicate,
    );
  }

  Future<void> popAndPushToSuccess<TO extends Object>({TO? result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      OldFriendRequestRoutes.success,
      result: result,
    );
  }
}

extension OldFriendRequestRouterScreensAndRouters on OldFriendRequestRouter {
  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(OldFriendRequestRoutes.listRequests,
          deepLink: 'old-friend-request/list'): (RouteSettings settings) {
        return listRequests();
      },
      RouteDef(OldFriendRequestRoutes.success,
          deepLink: 'old-friend-request/success'): (RouteSettings settings) {
        return success();
      },
    };
  }
}
