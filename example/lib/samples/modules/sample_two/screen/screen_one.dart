import 'package:flutter/material.dart';
import 'package:routing/src/screen.dart';

import '../../../../src/example_app_router.dart';

class _ScreenOne extends ExampleScreenWidget {
  _ScreenOne(ScreenContext screenContext) : super(screenContext);

  static _ScreenOne from(ScreenContext screenContext) {
    return _ScreenOne(screenContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen One'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => navigation.pop<String>('Backed from Screen One'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'testId = ${args['testId']}',
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: const Text('Go to screen two'),
            onPressed: () async {
              final value = await navigation.samples.sampleTwo.screenTwo();
              print('Return from sample two screen two with value: $value');
            },
          ),
          TextField()
        ],
      ),
    );
  }
}

const S2ScreenOnePage = Screen<String>.page(_ScreenOne.from);
