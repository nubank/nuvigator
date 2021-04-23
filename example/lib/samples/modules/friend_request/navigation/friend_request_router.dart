import 'package:example/samples/modules/friend_request/bloc/friend_request_bloc.dart';
import 'package:example/samples/modules/friend_request/screens/list_requests_screen.dart';
import 'package:example/samples/modules/friend_request/screens/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

part 'friend_request_router.g.dart';

@nuRouter
class OldFriendRequestRouter extends NuRouter {
  @NuRoute(deepLink: 'old-friend-request/list')
  ScreenRoute<void> listRequests() => ScreenRoute(
        builder: (context) => ListRequestScreen(
          toSuccess: () {
            nuvigator.open<Object>('composer/text');
          },
        ),
        screenType: materialScreenType,
      );

  @NuRoute(deepLink: 'old-friend-request/success')
  ScreenRoute<void> success() => ScreenRoute(
      builder: (context) => SuccessScreen(
            closeFlow: () => nuvigator.closeFlow(),
            toComposeText: () {},
          ),
      screenType: materialScreenType);

  @override
  WrapperFn get screensWrapper => (BuildContext context, Widget child) {
        return ChangeNotifierProvider.value(
          value: FriendRequestBloc(10),
          child: child,
        );
      };

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;
}
