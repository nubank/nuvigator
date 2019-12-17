import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nuvigator = Nuvigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Two'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => nuvigator.pop<String>('Backed from Screen Two'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Hero(
            child: FlutterLogo(
              size: 100,
            ),
            tag: 'HERO',
          ),
          const Text(
            'TEST_ID: ${1}',
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: const Text('Close entire flow'),
            onPressed: () =>
                nuvigator.parentPop<String>('Backed from Screen Two'),
          ),
          FlatButton(
              child: const Text('Go to sample one'),
              onPressed: () =>
                  Router.of<SamplesRouter>(context).sampleOneRouter.toString()),
        ],
      ),
    );
  }
}
