// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'samples_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class SamplesRoutes {
  static const home = 'samples/home';

  static const friendRequests = 'samples/friendRequests';
}

class FriendRequestsArgs {
  FriendRequestsArgs({@required this.numberOfRequests});

  final int numberOfRequests;

  static FriendRequestsArgs parse(Map<String, Object> args) {
    if (args == null) {
      return FriendRequestsArgs(numberOfRequests: null);
    }
    return FriendRequestsArgs(
      numberOfRequests: args['numberOfRequests'] is String
          ? int.tryParse(args['numberOfRequests'])
          : args['numberOfRequests'],
    );
  }

  Map<String, Object> get toMap => {
        'numberOfRequests': numberOfRequests,
      };
  static FriendRequestsArgs of(BuildContext context) {
    final routeSettings = ModalRoute.of(context)?.settings;
    final nuvigator = Nuvigator.of(context);
    if (routeSettings?.name == SamplesRoutes.friendRequests) {
      final args = routeSettings?.arguments;
      if (args == null)
        throw FlutterError('FriendRequestsArgs requires Route arguments');
      if (args is FriendRequestsArgs) return args;
      if (args is Map<String, Object>) return parse(args);
    } else if (nuvigator != null) {
      return of(nuvigator.context);
    }
    return null;
  }
}

extension SamplesRouterNavigation on SamplesRouter {
  Future<void> toHome() {
    return nuvigator.pushNamed<void>(
      SamplesRoutes.home,
    );
  }

  Future<void> pushReplacementToHome<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      SamplesRoutes.home,
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToHome<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      SamplesRoutes.home,
      predicate,
    );
  }

  Future<void> popAndPushToHome<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      SamplesRoutes.home,
      result: result,
    );
  }

  Future<String> toFriendRequests({@required int numberOfRequests}) {
    return nuvigator.pushNamed<String>(
      SamplesRoutes.friendRequests,
      arguments: {
        'numberOfRequests': numberOfRequests,
      },
    );
  }

  Future<String> pushReplacementToFriendRequests<TO extends Object>(
      {@required int numberOfRequests, TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      SamplesRoutes.friendRequests,
      arguments: {
        'numberOfRequests': numberOfRequests,
      },
      result: result,
    );
  }

  Future<String> pushAndRemoveUntilToFriendRequests<TO extends Object>(
      {@required int numberOfRequests, @required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<String>(
      SamplesRoutes.friendRequests,
      predicate,
      arguments: {
        'numberOfRequests': numberOfRequests,
      },
    );
  }

  Future<String> popAndPushToFriendRequests<TO extends Object>(
      {@required int numberOfRequests, TO result}) {
    return nuvigator.popAndPushNamed<String, TO>(
      SamplesRoutes.friendRequests,
      arguments: {
        'numberOfRequests': numberOfRequests,
      },
      result: result,
    );
  }

  ComposerRouter get composerRouter => getRouter<ComposerRouter>();
}

extension SamplesRouterScreensAndRouters on SamplesRouter {
  List<NuRouter> get _$routers => [
        composerRouter,
      ];
  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(SamplesRoutes.home, deepLink: 'home'): (RouteSettings settings) {
        return home();
      },
      RouteDef(SamplesRoutes.friendRequests, deepLink: 'friend-requests'):
          (RouteSettings settings) {
        final args = FriendRequestsArgs.parse(settings.arguments);
        return friendRequests(numberOfRequests: args.numberOfRequests);
      },
    };
  }
}
