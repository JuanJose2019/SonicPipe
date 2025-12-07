import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = lightTheme;

  ThemeData get currentTheme => _currentTheme;

  void setLightTheme() {
    _currentTheme = lightTheme;
    notifyListeners();
  }

  void setDarkTheme() {
    _currentTheme = darkTheme;
    notifyListeners();
  }
}
