import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../widgets/custom_input.dart';
import '../widgets/primary_button.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await context.read<AuthService>().signIn(
              _emailController.text,
              _passwordController.text,
            );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Gagal: ${e.toString().split(']').last}')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Logo Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.indigo.shade100, blurRadius: 20, offset: const Offset(0, 10))
                    ],
                  ),
                  child: const Center(child: FaIcon(FontAwesomeIcons.wallet, color: Colors.white, size: 28)),
                ),
                const SizedBox(height: 24),
                Text("Selamat Datang!", style: AppTheme.font.copyWith(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.dark)),
                const SizedBox(height: 8),
                Text("Masuk untuk kelola keuanganmu.", style: AppTheme.font.copyWith(color: AppTheme.muted)),
                
                const SizedBox(height: 40),
                CustomInput(
                  label: "Email Address",
                  placeholder: "nama@email.com",
                  icon: FontAwesomeIcons.envelope,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomInput(
                  label: "Password",
                  placeholder: "••••••••",
                  icon: FontAwesomeIcons.lock,
                  controller: _passwordController,
                  isPassword: true,
                ),
                
                const SizedBox(height: 32),
                PrimaryButton(
                  text: "Masuk Sekarang",
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum punya akun? ", style: AppTheme.font.copyWith(fontSize: 12, color: AppTheme.muted)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                      child: Text("Daftar dulu", style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}