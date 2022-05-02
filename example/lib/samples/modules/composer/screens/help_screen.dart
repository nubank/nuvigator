import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Composer help')),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'You can use the text composer to compose text. It will return the '
          'text to whoever called this screen when you tap the publish button, '
          'on the bottom of the Text Field. If you came from the Home screen, '
          'it will pop up a message on the Home Screen with your composition. '
          'If you decide to go back instead, it will return null and nothing '
          'will be displayed. If you did not come from the Home screen, '
          'nothing will happen either way. Contrary to what it looks like, '
          'the text will not actually be posted anywhere :)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
