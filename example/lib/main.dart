import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

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
//        initialRoute: 'home',
        home: Nuvigator(
          router: router,
          key: rootNavigatorKey,
          initialRoute: 'home',
        ),
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
              onPressed: () {
                ExampleAppRouter.of(context);
                Nuvigator.of<ExampleAppRouter>(context).router.toX('aaa');
              }),
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
