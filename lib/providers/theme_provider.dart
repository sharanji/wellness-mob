import 'package:flutter/foundation.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkTheme = false;
  toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
