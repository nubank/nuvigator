import 'package:example/samples/modules/sample_two/navigation/sample_two_routes.dart';
import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import 'samples/modules/sample_one/navigation/sample_one_router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final GlobalRouter router =
      GlobalRouter.fromRouters(routers: [samplesRouter]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nubank',
      home: Nuvigator(
        router: router,
        initialRoute: 'home',
      ),
    );
  }
}

class HomeScreen extends ScreenWidget {
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
              onPressed: () async {
                final result = await nuvigator
                    .pushNamed('second', arguments: {'testId': 'GO FOR IT'});
                print(result);
              }),
          FlatButton(
            child: const Text('Go to sample one with deepLink'),
            onPressed: () => GlobalRouter.of(context)
                .openDeepLink<void>(Uri.parse(screenOneDeepLink)),
          ),
          FlatButton(
            child: const Text('Go to sample two with flow'),
            onPressed: () async {
              final value = await nuvigator.pushNamed(
                  SampleTwoRoutes.screen_one,
                  arguments: {'testId': 'aaa'});
              print('Return from sample two with value: $value');
            },
          ),
        ],
      ),
    );
  }
}
