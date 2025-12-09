import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../widgets/custom_input.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController(); // Tambahan Input Nama
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await context.read<AuthService>().signUp(
              _emailController.text,
              _passwordController.text,
              _nameController.text,
            );
        if (mounted) Navigator.pop(context); // Kembali ke AuthWrapper -> Home
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal Daftar: ${e.toString().split(']').last}')),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: AppTheme.dark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text("Buat Akun Baru", style: AppTheme.font.copyWith(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.dark)),
                const SizedBox(height: 8),
                Text("Mulai perjalanan hematmu sekarang.", style: AppTheme.font.copyWith(color: AppTheme.muted)),
                
                const SizedBox(height: 32),
                CustomInput(
                  label: "Nama Lengkap",
                  placeholder: "Contoh: Nisa Putri",
                  icon: FontAwesomeIcons.user,
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
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
                  text: "Daftar Akun",
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}