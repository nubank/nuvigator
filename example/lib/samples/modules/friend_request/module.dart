import 'package:nuvigator/next.dart';

import 'screens/list_requests_screen.dart';
import 'screens/success_screen.dart';

class ListFriendRequestRoute extends NuRoute<NuModule, void, void> {
  ListFriendRequestRoute(NuModule delegate) : super(delegate);

  @override
  String get path => 'friend-requests/list';

  @override
  ScreenRoute<Object> getRoute(NuRouteMatch<Object> match) {
    return ScreenRoute(
      builder: (context) => ListRequestScreen(
        toSuccess: () => delegate.nuvigator
            .openDeepLink<void>(Uri.parse('friend-requests/success')),
      ),
      screenType: materialScreenType,
    );
  }
}

class FriendRequestSuccessRoute extends NuRoute<NuModule, void, void> {
  FriendRequestSuccessRoute(NuModule delegate) : super(delegate);

  @override
  String get path => 'friend-requests/success';

  @override
  ScreenRoute<void> getRoute(NuRouteMatch<void> match) {
    return ScreenRoute(
      builder: (context) => SuccessScreen(
        closeFlow: () => delegate.nuvigator.closeFlow(),
        toComposeText: () =>
            delegate.nuvigator.openDeepLink<void>(Uri.parse('composer/text')),
      ),
      screenType: materialScreenType,
    );
  }
}

// FriendRequestsModuleRouter

class FriendRequestModule extends NuModule {
  @override
  String get initialRoute => 'friend-requests/list';

  @override
  List<NuRoute> get createRoutes => [
        ListFriendRequestRoute(this),
        FriendRequestSuccessRoute(this),
      ];
}
