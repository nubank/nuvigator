import 'package:example/samples/modules/composer/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import 'package:provider/provider.dart';

import 'bloc/samples_bloc.dart';
import 'modules/friend_request/bloc/friend_request_bloc.dart';
import 'modules/friend_request/module.dart';
import 'screens/home_screen.dart';

class HomeRoute extends NuRoute {
  HomeRoute(NuModule delegate) : super(delegate);

  @override
  Future<bool> init(BuildContext context) {
    return Future.delayed(const Duration(seconds: 2), () => true);
  }

  @override
  String get path => 'home';

  @override
  ScreenRoute<void> getRoute(NuRouteMatch<void> match) {
    return ScreenRoute(
      builder: (context) => HomeScreen(),
    );
  }
}

class FriendRequestRoute extends NuRoute {
  FriendRequestRoute(NuModule delegate) : super(delegate);

  @override
  String get path => 'friend-requests';

  @override
  Future<bool> init(BuildContext context) {
    return Future.delayed(const Duration(seconds: 3), () => true);
  }

  @override
  ScreenRoute<void> getRoute(NuRouteMatch<void> match) {
    return ScreenRoute(
      builder: Nuvigator(
        router: NuModuleRouter(FriendRequestModule()),
        screenType: materialScreenType,
      ),
      wrapper: (context, child) => ChangeNotifierProvider.value(
        value: FriendRequestBloc(10),
        child: child,
      ),
    );
  }
}

// MainAppModuleRouter

class MainAppModule extends NuModule {
  @override
  String get initialRoute => 'home';

  @override
  Widget loadingWidget(BuildContext _) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  List<NuRoute> get createRoutes => [
        HomeRoute(this),
        FriendRequestRoute(this),
      ];

  @override
  List<NuModule> get createModules => [
        ComposerModule(),
      ];

  @override
  Widget routeWrapper(BuildContext context, Widget child) {
    return ChangeNotifierProvider<SamplesBloc>.value(
      value: SamplesBloc(),
      child: child,
    );
  }
}
