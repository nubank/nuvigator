import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import 'package:provider/provider.dart';

import 'modules/composer/module.dart';
import 'modules/friend_request/bloc/friend_request_bloc.dart';
import 'modules/friend_request/module.dart';
import 'modules/friend_request/navigation/friend_request_router.dart';
import 'screens/home_screen.dart';

part 'router.g.dart';

class FriendRequestArgs {
  int numberOfRequests;
  double precision;
  String name;
  int age;
}

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

  List<NuRoute> _postInitRoutes;

  @override
  Future<void> init(BuildContext context) async {
    _postInitRoutes = [
      FriendRequestRoute(),
      ComposerRoute(),
    ];
  }

  @override
  bool get lazyRouteRegister => true;

  @override
  Widget onError(Object error, NuRouterController controller) {
    return Scaffold(
      body: MaterialButton(
        onPressed: controller.reload,
        child: const Center(
          child: Text('Retry'),
        ),
      ),
    );
  }

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
          screenType: ScreenTypeBuilder(
            (WidgetBuilder builder, RouteSettings _) =>
                CupertinoPageRoute(builder: builder),
          ),
        ),
        ..._postInitRoutes,
      ];
}
