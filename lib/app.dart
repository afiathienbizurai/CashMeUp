import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// PROVIDERS
import 'core/providers/theme_provider.dart';
import 'features/auth/auth_provider.dart';

// WIDGETS
import 'core/widgets/bottom_nav.dart';
import 'features/auth/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AuthProvider>(
      builder: (context, theme, auth, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // THEME SETTINGS
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: theme.themeMode,

          // CHECK LOGIN STATUS
          home: auth.isLoggedIn
              ? const BottomNav()     // → jika sudah login
              : const LoginPage(),    // → jika belum login
        );
      },
    );
  }
}
