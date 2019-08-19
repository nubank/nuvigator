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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'testId = ${args['testId']}',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

const ScreenOneCard = Screen<void>.card(_ScreenOne.from);
