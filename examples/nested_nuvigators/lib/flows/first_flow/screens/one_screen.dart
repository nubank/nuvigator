import 'package:flutter/material.dart';

class OneScreen extends StatelessWidget {
  const OneScreen({
    Key key,
    this.onNext,
    this.onClose,
  }) : super(key: key);

  final Function() onNext;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen one"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tap a button to change the page',
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Next Screen'),
              onPressed: () => onNext(),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Close Flow'),
              onPressed: () => onClose(),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
