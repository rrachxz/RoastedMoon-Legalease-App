import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  double _fontSizeFactor = 1.0;
  bool _isDyslexicFont = false;

  double get fontSizeFactor => _fontSizeFactor;
  bool get isDyslexicFont => _isDyslexicFont;

  void setFontSize(double value) {
    _fontSizeFactor = value;
    notifyListeners();
  }

  void toggleDyslexicFont(bool value) {
    _isDyslexicFont = value;
    notifyListeners();
  }
}