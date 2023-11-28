import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkTheme = true;

  void initTheme(bool isDarkTheme) {
    this.isDarkTheme = isDarkTheme;
  }

  void toggleTheme(bool isDarkTheme) {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
    SharedPref().setTheme(isDarkTheme);
  }
}