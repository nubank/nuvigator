import 'package:flutter/material.dart';

class FriendRequestBloc extends ChangeNotifier {
  FriendRequestBloc(this.numberOfRequests)
      : _accepted = List<bool?>.filled(numberOfRequests, false);

  final int numberOfRequests;
  final List<bool?> _accepted;

  List<bool?> get accepted => _accepted;

  void updateRequest(int index, bool value) {
    _accepted[index] = value;
    notifyListeners();
  }

  int get numberOfAcceptedRequests => _accepted.where((a) => a!).length;
}
