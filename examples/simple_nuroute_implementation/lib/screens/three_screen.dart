import 'package:flutter/material.dart';

class ThreeScreen extends StatelessWidget {
  final VoidCallback onClose;
  final onScreenOneClick;
  final onScreenTwoClick;

  ThreeScreen({
    @required this.onClose,
    @required this.onScreenOneClick,
    @required this.onScreenTwoClick,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Screen three"),
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
              child: Text('Screen 1'),
              onPressed: onScreenOneClick,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Screen 2'),
              onPressed: onScreenTwoClick,
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
