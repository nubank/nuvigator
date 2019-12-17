import 'package:example/samples/modules/sample_one/navigation/sample_one_router.dart';
import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

class ScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router.of<SamplesRouter>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen One'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => router.nuvigator.pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'a',
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: const Text('Go to screen two'),
            onPressed: () => router.sampleOneRouter.toScreenTwo(),
          ),
          FlatButton(
            child: const Text('Go to Sample Two'),
            onPressed: () => router.toSecond(),
          ),
          const Hero(
            child: FlutterLogo(),
            tag: 'HERO',
          ),
        ],
      ),
    );
  }
}
