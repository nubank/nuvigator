import 'package:flutter/material.dart';

class OneScreen extends StatelessWidget {
  final VoidCallback onClose;
  final onScreenTwoClick;
  final onScreenThreeClick;

  OneScreen({
    @required this.onClose,
    @required this.onScreenTwoClick,
    @required this.onScreenThreeClick
  });

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
              'Tap a button to change the Screen',
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Back'),
              onPressed: onClose, // close flow of screens and return to the root Screen
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Screen 2'),
              onPressed: onScreenTwoClick,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Screen 3'),
              onPressed: onScreenThreeClick,
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}