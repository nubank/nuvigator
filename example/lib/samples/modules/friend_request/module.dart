import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';

import 'screens/list_requests_screen.dart';
import 'screens/success_screen.dart';

class ListFriendRequestRoute extends NuRoute<NuModule, void, void> {
  @override
  String get path => 'friend-requests/list';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<void> settings) {
    return ListRequestScreen(
      toSuccess: () => module.nuvigator.open<void>('friend-requests/success'),
    );
  }
}

class FriendRequestSuccessRoute extends NuRoute<NuModule, void, void> {
  @override
  String get path => 'friend-requests/success';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<void> settings) {
    return SuccessScreen(
      closeFlow: () => module.nuvigator.closeFlow(),
      toComposeText: () => module.nuvigator.open<void>('composer/text'),
    );
  }
}

// FriendRequestsModuleRouter
class FriendRequestModule extends NuModule {
  @override
  String get initialRoute => 'friend-requests/list';

  @override
  List<NuRoute> get registerRoutes => [
        ListFriendRequestRoute(),
        FriendRequestSuccessRoute(),
      ];
}
