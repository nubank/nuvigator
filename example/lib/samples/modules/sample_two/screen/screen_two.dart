import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

class ScreenTwo extends ScreenWidget {
  ScreenTwo(BuildContext context) : super(context);

  static ScreenTwo builder(BuildContext context) {
    return ScreenTwo(context);
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
          Hero(
            child: const FlutterLogo(
              size: 100,
            ),
            tag: 'HERO',
          ),
          FlatButton(
            child: const Text('Close entire flow'),
            onPressed: () =>
                nuvigator.parentPop<String>('Backed from Screen Two'),
          ),
          FlatButton(
              child: const Text('Go to sample one'),
              onPressed: () => SamplesNavigation.of(context)
                  .sampleOneNavigation
                  .screenOne(testId: 'FromSampleTwo')),
        ],
      ),
    );
  }
}
