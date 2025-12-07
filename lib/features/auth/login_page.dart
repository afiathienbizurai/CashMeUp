import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username atau Email",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),

            const SizedBox(height: 20),

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final identifier = usernameController.text.trim();
                final password = passwordController.text.trim();

                final error = auth.login(identifier, password);

                if (error != null) {
                  setState(() => errorMessage = error);
                  return;
                }

                Navigator.pushReplacementNamed(context, "/main");
              },
              child: const Text("Login"),
            ),

          ],
        ),
      ),
    );
  }
}
