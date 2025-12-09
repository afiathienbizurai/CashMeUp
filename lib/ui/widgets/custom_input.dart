import 'package:flutter/material.dart';
import '../../core/theme.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final String placeholder;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomInput({
    super.key,
    required this.label,
    required this.placeholder,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: AppTheme.font.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.dark,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC), // Slate 50
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)), // Slate 200
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: AppTheme.font.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.dark,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: AppTheme.muted.withOpacity(0.5)),
              prefixIcon: Icon(icon, color: AppTheme.muted, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
          ),
        ),
      ],
    );
  }
}