import 'package:nuvigator/nuvigator.dart';

import 'screens/list_requests_screen.dart';
import 'screens/success_screen.dart';

class ListFriendRequestModule
    extends NuRouteModule<NuModuleRouter, void, void> {
  ListFriendRequestModule(NuModuleRouter delegate) : super(delegate);

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

class FriendRequestSuccessModule
    extends NuRouteModule<NuModuleRouter, void, void> {
  FriendRequestSuccessModule(NuModuleRouter delegate) : super(delegate);

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

class FriendRequestModuleRouter extends NuModuleRouter {
  @override
  String get initialRoute => 'friend-requests/list';

  @override
  List<NuRouteModule> get modules => [
        ListFriendRequestModule(this),
        FriendRequestSuccessModule(this),
      ];
}
