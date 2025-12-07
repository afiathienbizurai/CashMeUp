import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // ThemeMode: system / light / dark
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  // Light Theme
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.blue,
        ),
      );

  // Dark Theme
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.blueGrey,
        ),
      );

  // Toggle Mode
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
