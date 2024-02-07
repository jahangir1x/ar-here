import 'package:ar_here/theme/theme.dart';
import 'package:ar_here/utils/persistent_storage.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  static var IsDarkMode = false;

  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void loadTheme() {
    IsDarkMode = PersistentStorage.getIsDarkMode();
    if (IsDarkMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
      PersistentStorage.setIsDarkMode(true);
      IsDarkMode = true;
    } else {
      PersistentStorage.setIsDarkMode(false);
      _themeData = lightMode;
      IsDarkMode = false;
    }
    notifyListeners();
  }
}
