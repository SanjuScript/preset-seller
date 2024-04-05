import 'package:flutter/material.dart';

class PolicyStatusProvider extends ChangeNotifier {
  bool accepted = false;

  bool get isShown => accepted;

  void toggleStatus() {
    accepted = !accepted;
    notifyListeners();
  }
}
