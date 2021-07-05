import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';
import 'package:provider/provider.dart';
import 'samples/bloc/samples_bloc.dart';
import 'samples/modules/friend_request/bloc/friend_request_bloc.dart';
import 'samples/router.dart';

void main() => runApp(MyApp());

class TestObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('didPush $route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('didPop $route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('didRemove $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('didReplace $oldRoute to $newRoute');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuvigator Example',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      builder: (_, __) => ChangeNotifierProvider<SamplesBloc>.value(
        value: SamplesBloc(),
        child: ChangeNotifierProvider.value(
          value: FriendRequestBloc(10),
          child: Nuvigator(
            router: MainAppRouter(),
          ),
        ),
      ),
    );
  }
}
