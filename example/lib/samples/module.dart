import 'package:example/samples/module_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import 'package:provider/provider.dart';

import 'bloc/samples_bloc.dart';
import 'modules/friend_request/bloc/friend_request_bloc.dart';
import 'modules/friend_request/module.dart';
import 'screens/home_screen.dart';

part 'module.g.dart';

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

@NuModuleParser()
class FriendRequestRoute extends NuRoute<NuModule, FriendRequestArgs, void> {
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
        module: FriendRequestModule(),
        screenType: materialScreenType,
      ),
    );
  }

  @override
  ParamsParser<FriendRequestArgs> get paramsParser => _$parseParameters;
}

// MainAppModuleRouter

class MainAppModule extends NuModule {
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
  List<NuRoute> get registerRoutes => [
        HomeRoute(),
        FriendRequestRoute(),
      ];

  @override
  Widget routeWrapper(BuildContext context, Widget child) {
    return ChangeNotifierProvider<SamplesBloc>.value(
      value: SamplesBloc(),
      child: child,
    );
  }
}
