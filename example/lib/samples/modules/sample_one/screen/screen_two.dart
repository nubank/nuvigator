import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import '../../../../src/example_app_router.dart';

class _ScreenTwo extends ScreenWidget {
  _ScreenTwo(ScreenContext screenContext) : super(screenContext);

  static _ScreenTwo from(ScreenContext screenContext) {
    return _ScreenTwo(screenContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Two'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
              child: const Text('Open sample two flow'), onPressed: () => null
//                navigation.samples.sampleTwo.start('test_123'),
              ),
        ],
      ),
    );
  }
}

final s1ScreenTwoPage = NuScreen.page<int>(_ScreenTwo.from);
