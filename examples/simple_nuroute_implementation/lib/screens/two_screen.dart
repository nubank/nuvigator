import 'package:flutter/material.dart';

class TwoScreen extends StatelessWidget {
  final VoidCallback onClose;
  final onScreenOneClick;
  final onScreenThreeClick;

  TwoScreen({
    @required this.onClose,
    @required this.onScreenOneClick,
    @required this.onScreenThreeClick,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Screen two"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tap a button to change the page',
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Back'),
              onPressed: onClose, // close flow of screens and return to the root page
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Screen 1'),
              onPressed: onScreenOneClick,
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
