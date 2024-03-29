import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';
import 'package:provider/provider.dart';

import 'bloc/friend_request_bloc.dart';
import 'screens/list_requests_screen.dart';
import 'screens/success_screen.dart';

class ListFriendRequestRoute extends NuRoute<NuRouter, void, void> {
  @override
  String get path => 'friend-requests/list';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<void> settings) {
    final bloc = context.watch<FriendRequestBloc>();
    return ListRequestScreen(
      toSuccess: () => router.nuvigator?.open<void>('friend-requests/success'),
      numberOfRequests: bloc.numberOfRequests,
    );
  }
}

class FriendRequestSuccessRoute extends NuRoute<NuRouter, void, void> {
  @override
  String get path => 'friend-requests/success';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<void> settings) {
    return SuccessScreen(
      closeFlow: () => router.nuvigator?.closeFlow(),
      toComposeText: () => router.nuvigator?.open<void>('composer/text'),
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
