import 'package:flutter/material.dart';

class AgeScreen extends StatelessWidget {
  final String param;
  final VoidCallback onClose;

  AgeScreen({
    @required this.param,
    @required this.onClose
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Age screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Your age: $param',
                style: TextStyle(
                    fontSize: 25
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onClose,
              child: Text('Back')
            ),
          ],
        ),
      ),
    );
  }
}