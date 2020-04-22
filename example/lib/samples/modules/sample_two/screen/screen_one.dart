import 'package:example/samples/modules/sample_two/bloc/sample_two_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenOne extends StatelessWidget {
  const ScreenOne({Key key, this.toScreenTwo}) : super(key: key);

  final VoidCallback toScreenTwo;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SampleTwoBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen One ${bloc.counter}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            child: const Text('Increase'),
            onPressed: () {
              bloc.increase();
            },
          ),
          FlatButton(
            child: const Text('Go to screen two'),
            onPressed: toScreenTwo,
          ),
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
