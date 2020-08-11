import 'package:example/samples/modules/composer/navigation/composer_routes.dart';
import 'package:example/samples/modules/friend_request/bloc/friend_request_bloc.dart';
import 'package:example/samples/modules/friend_request/navigation/friend_request_router.dart';
import 'package:example/samples/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../bloc/samples_bloc.dart';

part 'samples_router.g.dart';

@NuRouter()
class SamplesRouter extends Router {
  @override
  String get deepLinkPrefix => 'deepprefix';

  @NuRoute()
  ScreenRoute<void> home() => ScreenRoute(
        builder: (context) => HomeScreen(),
      );

  @NuRoute(deepLink: '/friendRequests')
  ScreenRoute<String> friendRequests({@required int numberOfRequests}) =>
      ScreenRoute(
        builder: Nuvigator(
          router: FriendRequestRouter(),
          initialRoute: FriendRequestRoutes.listRequests,
          screenType: materialScreenType,
        ),
        wrapper: (context, child, routeName) => ChangeNotifierProvider.value(
          value: FriendRequestBloc(numberOfRequests),
          child: child,
        ),
      );

  @NuRouter()
  final composerRouter = ComposerRouter();

  @override
  WrapperFn get screensWrapper =>
      (BuildContext context, Widget child, String routeName) {
        return ChangeNotifierProvider<SamplesBloc>.value(
          value: SamplesBloc(),
          child: child,
        );
      };

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;

  @override
  List<Router> get routers => _$routers;
}
