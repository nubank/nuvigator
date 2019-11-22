import 'package:example/samples/modules/sample_two/navigation/sample_two_router.dart';
import 'package:example/samples/navigation/samples_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

class ScreenOne extends ScreenOneScreen {
  ScreenOne(BuildContext context) : super(context);

  static ScreenOne builder(BuildContext context) {
    return ScreenOne(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen One'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Nuvigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'testId = ${args.testId}',
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: const Text('Go to screen two'),
            onPressed: () async {
              SamplesNavigation.of(context).sampleTwoNavigation.toScreenTwo();
            },
          ),
          const TextField(),
          const Hero(
            child: FlutterLogo(
              size: 100,
            ),
            tag: 'HERO',
          ),
        ],
      ),
    );
  }
}
