import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final onScreenOneClick;
  final onScreenTwoClick;
  final onScreenThreeClick;

  HomeScreen({
    this.onScreenOneClick,
    this.onScreenTwoClick,
    this.onScreenThreeClick
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Nuvigator router example"),
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
              child: Text('Screen 1'),
              onPressed: onScreenOneClick,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Screen 2'),
              onPressed: onScreenTwoClick,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                child: Text('Screen 3'),
                onPressed: onScreenThreeClick
            ),
          ],
        ),
      ),
    );
  }
}
