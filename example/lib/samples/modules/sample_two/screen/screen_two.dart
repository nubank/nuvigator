import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import '../../../../src/example_app_router.dart';

class _ScreenTwo extends ExampleScreenWidget {
  _ScreenTwo(ScreenContext screenContext) : super(screenContext);

  static _ScreenTwo from(ScreenContext screenContext) {
    return _ScreenTwo(screenContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Two'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => navigation.pop<String>('Backed from Screen Two'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            child: const Text('Close entire flow'),
            onPressed: () =>
                navigation.parentPop<String>('Backed from Screen Two'),
          ),
          FlatButton(
            child: const Text('Go to sample one'),
            onPressed: () => navigation.samples.sampleOne.start('test_123'),
          ),
        ],
      ),
    );
  }
}

final s2ScreenTwoPage = NuScreen.page<String>(_ScreenTwo.from);
