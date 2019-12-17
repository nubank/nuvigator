import 'package:flutter/material.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({Key key, this.closeFlow, this.toSampleOne})
      : super(key: key);

  final VoidCallback closeFlow;
  final VoidCallback toSampleOne;

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
