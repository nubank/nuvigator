import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';

import 'screens/list_requests_screen.dart';
import 'screens/success_screen.dart';

class ListFriendRequestRoute extends NuRoute<NuRouter, Object, Object> {
  @override
  String get path => 'friend-requests/list';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<void> settings) {
    return ListRequestScreen(
      toSuccess: () =>
          router!.nuvigator!.open<Object>('friend-requests/success'),
    );
  }
}

class FriendRequestSuccessRoute extends NuRoute<NuRouter, Object, Object> {
  @override
  String get path => 'friend-requests/success';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<void> settings) {
    return SuccessScreen(
      closeFlow: () => router!.nuvigator!.closeFlow(),
      toComposeText: () => router!.nuvigator!.open<Object>('composer/text'),
    );
  }
}

// FriendRequestsModuleRouter
class FriendRequestRouter extends NuRouter {
  @override
  ScreenType get screenType => materialScreenType;

  @override
  String get initialRoute => 'friend-requests/list';

  @override
  List<NuRoute> get registerRoutes => [
        ListFriendRequestRoute(),
        FriendRequestSuccessRoute(),
      ];
}
