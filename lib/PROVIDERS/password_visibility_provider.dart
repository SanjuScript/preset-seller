import 'package:flutter/material.dart';

class PasswordVisibilityProvider extends ChangeNotifier {
  bool _isShown = true;

  bool get isShown => _isShown;

  void toggleVisibility() {
    _isShown = !_isShown;
    notifyListeners();
  }
}