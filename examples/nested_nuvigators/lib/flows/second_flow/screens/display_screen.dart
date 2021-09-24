import 'package:flutter/material.dart';

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({
    Key key,
    this.onClose,
    this.text,
  }) : super(key: key);

  final Function() onClose;
  final String text;

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
              'Text Provided Before',
            ),
            SizedBox(
              height: 20,
            ),
            Text(text),
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
