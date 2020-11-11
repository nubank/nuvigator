import 'package:example/samples/module.dart';
import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

void main() => runApp(MyApp());

class TestObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('didPush $route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('didPop $route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('didRemove $route');
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    print('didReplace $oldRoute to $newRoute');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuvigator example',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      builder: Nuvigator(
        screenType: cupertinoDialogScreenType,
        inheritableObservers: [
          () => TestObserver(),
        ],
        router: MainAppModuleRouter(),
        initialRoute: 'deepprefix/home',
      ),
    );
  }
}
