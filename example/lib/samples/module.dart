import 'package:example/samples/modules/composer/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import 'bloc/samples_bloc.dart';
import 'modules/friend_request/bloc/friend_request_bloc.dart';
import 'modules/friend_request/module.dart';
import 'screens/home_screen.dart';

class HomeModule extends NuRouteModule<NuModuleRouter, void, void> {
  HomeModule(NuModuleRouter delegate) : super(delegate);

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

class FriendRequestModule extends NuRouteModule<NuModuleRouter, void, void> {
  FriendRequestModule(NuModuleRouter delegate) : super(delegate);

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
        router: FriendRequestModuleRouter(),
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

class MainAppModuleRouter extends NuModuleRouter
    implements ComposerModulesDelegate {
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
  List<NuRouteModule> get modules => [
        HomeModule(this),
        FriendRequestModule(this),
        ...composerModules(this),
      ];

  @override
  WrapperFn get screensWrapper => (BuildContext context, Widget child) {
        return ChangeNotifierProvider<SamplesBloc>.value(
          value: SamplesBloc(),
          child: child,
        );
      };

  @override
  void handleCompose() {
    // TODO: implement handleCompose
  }

  @override
  void handleHelp() {
    // TODO: implement handleHelp
  }
}
