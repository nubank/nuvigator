import 'package:flutter/material.dart';

class ScreenOne extends StatelessWidget {
  const ScreenOne({Key key, this.toScreenTwo, this.toSampleTwo, this.toBack})
      : super(key: key);

  final VoidCallback toScreenTwo;
  final VoidCallback toSampleTwo;
  final VoidCallback toBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen One'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            child: const Text('Go to screen two'),
            onPressed: () => toScreenTwo(),
          ),
          FlatButton(
            child: const Text('Go to Sample Two'),
            onPressed: () => toSampleTwo(),
          ),
          FlatButton(
            child: const Text('Close Screen with Result'),
            onPressed: () => toBack(),
          ),
          const Hero(
            child: FlutterLogo(),
            tag: 'HERO',
          ),
        ],
      ),
    );
  }
}
