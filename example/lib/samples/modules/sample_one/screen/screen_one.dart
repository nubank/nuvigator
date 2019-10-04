import 'package:example/samples/modules/sample_one/navigation/sample_one_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

class ScreenOne extends ScreenWidget<Map<String, String>> {
  ScreenOne(ScreenContext screenContext) : super(screenContext);

  static ScreenOne from(ScreenContext screenContext) {
    return ScreenOne(screenContext);
  }

  @override
  Widget build(BuildContext context) {
    final nuvigator = Nuvigator.of(context);

    print(nuvigator.canPop());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen One'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => nuvigator.maybePop(),
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
            onPressed: () => nuvigator.navigate(SampleOneRouter.screenTwo()),
          ),
        ],
      ),
    );
  }
}
