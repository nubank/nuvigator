import 'package:flutter/material.dart';

class SamplesBloc extends ChangeNotifier {
  bool _navigateUsingDeepLink = false;

  bool get navigateUsingDeepLink => _navigateUsingDeepLink;

  set navigateUsingDeepLink(bool value) {
    _navigateUsingDeepLink = value;
    notifyListeners();
  }
}
