import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Dummy user
  final String dummyEmail = "admin@mail.com";
  final String dummyUsername = "admin";
  final String dummyPassword = "123456";

  /// Return null if success, otherwise error message
  String? login(String identifier, String password) {
    if ((identifier == dummyEmail || identifier == dummyUsername) &&
        password == dummyPassword) {
      _isLoggedIn = true;
      notifyListeners();
      return null;
    }

    return "Username/email atau password salah";
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
