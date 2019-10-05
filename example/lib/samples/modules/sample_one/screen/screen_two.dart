import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

class ScreenTwo extends ScreenWidget {
  ScreenTwo(ScreenContext screenContext) : super(screenContext);

  static ScreenTwo builder(ScreenContext screenContext) {
    return ScreenTwo(screenContext);
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
              child: const Text('Open sample two flow'),
              onPressed: () => nuvigator
                  .navigate(SamplesRouter.sampleTwo('from sample one'))),
        ],
      ),
    );
  }
}
