import 'package:example/samples/modules/sample_two/navigation/sample_two_router.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:provider/provider.dart';

import '../../../bloc/samples_bloc.dart';
import '../bloc/sample_flow_bloc.dart';
import '../bloc/sample_two_bloc.dart';
import '../bloc/screen_one_bloc.dart';

class ScreenOne extends ScreenWidget<Map<String, String>> {
  ScreenOne(ScreenContext screenContext) : super(screenContext);

  static ScreenOne from(ScreenContext screenContext) {
    return ScreenOne(screenContext);
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<ScreenOneBloc>(context).testText);
    print(Provider.of<SampleTwoBloc>(context).testText);
    print(Provider.of<SampleFlowBloc>(context).testText);
    print(Provider.of<SamplesBloc>(context).testText);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen One'),
//        automaticallyImplyLeading: false,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back),
//          onPressed: () => Nuvigator.of(context).pop(),
//        ),
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
          TextField()
        ],
      ),
    );
  }
}
