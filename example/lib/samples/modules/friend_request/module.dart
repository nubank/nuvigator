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
  Widget build(BuildContext context, NuRouteMatch<void> match) {
    return ListRequestScreen(
      toSuccess: () => module.nuvigator
          .openDeepLink<void>(Uri.parse('friend-requests/success')),
    );
  }
}

class FriendRequestSuccessRoute extends NuRoute<NuModule, void, void> {
  @override
  String get path => 'friend-requests/success';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteMatch<void> match) {
    return SuccessScreen(
      closeFlow: () => module.nuvigator.closeFlow(),
      toComposeText: () =>
          module.nuvigator.openDeepLink<void>(Uri.parse('composer/text')),
    );
  }
}

// FriendRequestsModuleRouter

class FriendRequestModule extends NuModule {
  @override
  String get initialRoute => 'friend-requests/list';

  @override
  List<NuRoute> get createRoutes => [
        ListFriendRequestRoute(),
        FriendRequestSuccessRoute(),
      ];
}
