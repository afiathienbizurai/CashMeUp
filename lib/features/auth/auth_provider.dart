// lib/features/auth/auth_provider.dart
import 'package:flutter/material.dart';
import 'dummy_users.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, String>? currentUser;

  bool get isLoggedIn => currentUser != null;

  String? login(String identifier, String password) {
    final result = DummyUsers.login(identifier, password);

    if (result == null || result.isEmpty) {
      return "Username/email atau password salah.";
    }

    currentUser = result;
    notifyListeners();
    return null; // tidak ada error
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}
