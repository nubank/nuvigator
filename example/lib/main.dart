import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';
import 'package:provider/provider.dart';
import 'samples/bloc/samples_bloc.dart';
import 'samples/modules/friend_request/bloc/friend_request_bloc.dart';
import 'samples/router.dart';

void main() => runApp(const MyApp());

class TestObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('didPush $route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('didPop $route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('didRemove $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint('didReplace $oldRoute to $newRoute');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            debug: true,
            router: MainAppRouter(),
          ),
        ),
      ),
    );
  }
}
