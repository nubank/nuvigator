import 'package:example/samples/modules/sample_two/bloc/sample_two_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({Key key, this.closeFlow, this.toSampleOne})
      : super(key: key);

  final VoidCallback closeFlow;
  final VoidCallback toSampleOne;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SampleTwoBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Two ${bloc.counter}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Hero(
            child: FlutterLogo(
              size: 100,
            ),
            tag: 'HERO',
          ),
          FlatButton(
            child: const Text('Close entire flow'),
            onPressed: () => closeFlow(),
          ),
          FlatButton(
              child: const Text('Go to sample one'),
              onPressed: () => toSampleOne()),
        ],
      ),
    );
  }
}
