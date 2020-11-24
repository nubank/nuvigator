import 'package:example/samples/modules/composer/navigation/composer_routes.dart';
import 'package:example/samples/modules/friend_request/bloc/friend_request_bloc.dart';
import 'package:example/samples/modules/friend_request/module.dart';
import 'package:example/samples/modules/friend_request/navigation/friend_request_router.dart';
import 'package:example/samples/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../bloc/samples_bloc.dart';

part 'samples_router.g.dart';

@nuRouter
class SamplesRouter extends NuRouter {
  @NuRoute(deepLink: 'home')
  ScreenRoute<void> home() => ScreenRoute(
        builder: (context) => HomeScreen(),
      );

  @NuRoute(deepLink: 'friend-requests')
  ScreenRoute<String> friendRequests({@required int numberOfRequests}) =>
      ScreenRoute(
        builder: Nuvigator(
          module: FriendRequestModule(),
          // router: FriendRequestRouter(),
          // initialRoute: FriendRequestRoutes.listRequests,
          screenType: materialScreenType,
        ),
        screenType: materialScreenType,
        wrapper: (context, child) => ChangeNotifierProvider.value(
          value: FriendRequestBloc(numberOfRequests),
          child: child,
        ),
      );

  @nuRouter
  final ComposerRouter composerRouter = ComposerRouter();

  @override
  WrapperFn get screensWrapper => (BuildContext context, Widget child) {
        return ChangeNotifierProvider<SamplesBloc>.value(
          value: SamplesBloc(),
          child: child,
        );
      };

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;

  @override
  List<NuRouter> get routers => _$routers;
}
