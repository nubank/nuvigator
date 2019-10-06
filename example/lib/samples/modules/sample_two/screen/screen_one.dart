import 'package:example/samples/modules/sample_two/navigation/sample_two_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

class ScreenOne extends ScreenWidget<Map<String, String>> {
  ScreenOne(ScreenContext screenContext) : super(screenContext);

  static ScreenOne builder(ScreenContext screenContext) {
    return ScreenOne(screenContext);
  }

  @override
  Widget build(BuildContext context) {
//    print(Provider.of<ScreenOneBloc>(context).testText);
//    print(Provider.of<SampleTwoBloc>(context).testText);
//    print(Provider.of<SampleFlowBloc>(context).testText);
//    print(Provider.of<SamplesBloc>(context).testText);

//    final rootNuvigator = Nuvigator.of(context, rootNuvigator: true);
//    print(Nuvigator.of(context, rootNuvigator: true));
//    print(nuvigator);
//    print(nuvigator == rootNuvigator);
//    print(nuvigator.isRoot);

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
            'testId = ${args['testId']}',
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: const Text('Go to screen two'),
            onPressed: () async {
              final value =
                  await nuvigator.navigate(SampleTwoRouter.screenTwo());
              print('Return from sample two screen two with value: $value');
            },
          ),
          TextField(),
          Hero(
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
