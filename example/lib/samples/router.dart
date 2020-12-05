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

@NuRouteParser()
class FriendRequestRoute extends NuRoute<NuRouter, FriendRequestArgs, void> {
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
      ),
    );
  }

// @override
// ParamsParser<FriendRequestArgs> get paramsParser => _$parseParameters;
}

// MainAppModuleRouter
class MainAppRouter extends NuRouter {
  @override
  String get initialRoute => 'home';

  @override
  ScreenType get screenType => cupertinoScreenType;

  @override
  Widget get loadingWidget => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

  @override
  List<INuRouter> get legacyRouters => [
        OldFriendRequestRouter(),
      ];

  @override
  List<NuRoute> get registerRoutes => [
        NuRouteBuilder(
          path: 'home',
          builder: (_, __, ___) => HomeScreen(),
          screenType: materialScreenType,
        ),
        FriendRequestRoute(),
        ComposerRoute(),
      ];

  @override
  Widget routeWrapper(BuildContext context, Widget child) {
    return ChangeNotifierProvider<SamplesBloc>.value(
      value: SamplesBloc(),
      child: ChangeNotifierProvider.value(
        value: FriendRequestBloc(10),
        child: child,
      ),
    );
  }
}
