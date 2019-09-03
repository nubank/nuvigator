import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nuvigator/nuvigator.dart';

import 'samples/modules/sample_one/navigation/sample_one_router.dart';
import 'src/example_app_router.dart';

void main() => runApp(MyApp());

final rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static final ExampleAppRouter router = ExampleAppRouter(rootNavigatorKey);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: router,
      child: MaterialApp(
        title: 'Nubank',
        navigatorKey: rootNavigatorKey,
        initialRoute: 'home',
        onGenerateRoute: router.getRoute,
      ),
    );
  }
}

class HomeScreen extends ExampleScreenWidget {
  HomeScreen(ScreenContext screenContext) : super(screenContext);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('nuvigator Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            child: const Text('Go to sample one with flutter navigation'),
            onPressed: () => navigation.samples.sampleOne.start('id_1234'),
          ),
          FlatButton(
            child: const Text('Go to sample one with deepLink'),
            onPressed: () => ExampleAppRouter.of(context)
                .openDeepLink<void>(Uri.parse(screenOneDeepLink)),
          ),
          FlatButton(
            child: const Text('Go to sample two with flow'),
            onPressed: () async {
              final value = await navigation.samples.sampleTwo.start('id_1234');
              print('Return from sample two with value: $value');
            },
          ),
        ],
      ),
    );
  }
}
