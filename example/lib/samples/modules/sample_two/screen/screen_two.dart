import 'package:example/samples/modules/sample_one/navigation/sample_one_routes.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => nuvigator.pop<String>('Backed from Screen Two'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            child: const Text('Close entire flow'),
            onPressed: () =>
                nuvigator.parentPop<String>('Backed from Screen Two'),
          ),
          FlatButton(
              child: const Text('Go to sample one'),
              onPressed: () => nuvigator.pushNamed(SampleOneRoutes.screen_one,
                  arguments: {'testId': 'fromSample2'})),
        ],
      ),
    );
  }
}

final s2ScreenTwoPage = Screen.material<String>(_ScreenTwo.from);
