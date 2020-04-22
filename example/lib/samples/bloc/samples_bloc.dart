import 'package:flutter/widgets.dart';

class SamplesBloc extends ChangeNotifier {
  final testText = 'SamplesBloc';
  int counter = 0;

  void increase() {
    counter++;
    notifyListeners();
  }
}
