import 'package:example/samples/modules/friend_request/screens/list_requests_screen.dart';
import 'package:example/samples/modules/friend_request/screens/success_screen.dart';
import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import '../../composer/navigation/composer_routes.dart';

part 'friend_request_router.g.dart';

@nuRouter
class FriendRequestRouter extends NuRouter {
  FriendRequestRouter();

  @NuRoute()
  ScreenRoute<void> listRequests() => ScreenRoute(
        builder: (context) => ListRequestScreen(
          toSuccess: toSuccess,
        ),
        screenType: materialScreenType,
      );

  @NuRoute()
  ScreenRoute<void> success() => ScreenRoute(
      builder: (context) => SuccessScreen(
            closeFlow: () => nuvigator.closeFlow(),
            toComposeText: () => NuRouter.of<SamplesRouter>(context)
                .composerRouter
                .pushReplacementToComposeText(),
          ),
      screenType: materialScreenType);

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;
}
