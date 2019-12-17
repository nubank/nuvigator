import 'package:flutter/material.dart';

class ScreenOne extends StatelessWidget {
  const ScreenOne({Key key, this.toScreenTwo}) : super(key: key);

  final VoidCallback toScreenTwo;

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
