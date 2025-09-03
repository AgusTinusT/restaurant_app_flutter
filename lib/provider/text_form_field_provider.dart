import 'package:flutter/material.dart';

class TextFormFieldProvider with ChangeNotifier {
  bool _obscureText = false;

  bool get obscureText => _obscureText;

  void setInitialObscureText(bool isPassword) {
    _obscureText = isPassword;
  }

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
