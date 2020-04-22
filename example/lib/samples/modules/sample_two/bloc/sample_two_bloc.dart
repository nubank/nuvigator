import 'package:flutter/material.dart';

class SampleTwoBloc extends ChangeNotifier {
  final testText = 'SampleTwoBloc';
  int counter = 0;

  void increase() {
    counter++;
    notifyListeners();
  }
}
