import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';

class ThreeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final nuvigator = Nuvigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Screen three"),
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
              child: Text('Home'),
              onPressed: () => nuvigator.open('home'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Screen 1'),
              onPressed: () => nuvigator.open('one'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              child: Text('Screen 2'),
              onPressed: () => nuvigator.open('two'),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
