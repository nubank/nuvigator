import 'package:example/samples/module_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import 'package:provider/provider.dart';

import 'bloc/samples_bloc.dart';
import 'modules/composer/module.dart';
import 'modules/friend_request/bloc/friend_request_bloc.dart';
import 'modules/friend_request/module.dart';
import 'modules/friend_request/navigation/friend_request_router.dart';
import 'screens/home_screen.dart';

class HomeRoute extends NuRoute {
  @override
  Future<bool> init(BuildContext context) {
    return Future.delayed(const Duration(seconds: 2), () => true);
  }

  @override
  String get path => 'home';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return HomeScreen();
  }

  @override
  ParamsParser<Object> get paramsParser => null;
}

@NuRouteParser()
class FriendRequestRoute
    extends NuRoute<NuModuleRouter, FriendRequestArgs, void> {
  @override
  String get path => 'friend-requests';

  @override
  Future<bool> init(BuildContext context) {
    return Future.delayed(const Duration(seconds: 3), () => true);
  }

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(
      BuildContext context, NuRouteSettings<FriendRequestArgs> settings) {
    return ChangeNotifierProvider.value(
      value: FriendRequestBloc(settings.args.numberOfRequests),
      child: Nuvigator(
        router: FriendRequestRouter(),
        screenType: materialScreenType,
      ),
    );
  }

// @override
// ParamsParser<FriendRequestArgs> get paramsParser => _$parseParameters;
}

// MainAppModuleRouter
class MainAppRouter extends NuModuleRouter {
  @override
  String get initialRoute => 'home';

  @override
  Widget loadingWidget(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  List<NuRouter> get legacyRouters => [
        OldFriendRequestRouter(),
      ];

  @override
  List<NuRoute> get registerRoutes => [
        HomeRoute(),
        FriendRequestRoute(),
        ComposerRoute(),
      ];

  @override
  Widget routeWrapper(BuildContext context, Widget child) {
    return ChangeNotifierProvider<SamplesBloc>.value(
      value: SamplesBloc(),
      child: child,
    );
  }
}
