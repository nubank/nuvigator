import 'package:flutter/material.dart';

class InputScreen extends StatelessWidget {
  InputScreen({
    Key key,
    this.onNext,
  }) : super(key: key);

  final Function(String text) onNext;
  final TextEditingController controller = TextEditingController();

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
            TextField(
              controller: controller,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Next Screen'),
              onPressed: () => onNext(controller.value.text),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
