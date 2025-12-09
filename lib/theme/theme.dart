import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF4F46E5);
  static const Color primarySoft = Color(0xFFEEF2FF);
  static const Color dark = Color(0xFF1E293B);
  static const Color muted = Color(0xFF64748B);
  static const Color success = Color(0xFF10B981);
  static const Color danger = Color(0xFFF43F5E);
  static const Color bgApp = Color(0xFFF1F5F9);
  static const Color gold = Color(0xFFF59E0B);

  static TextStyle get font => GoogleFonts.plusJakartaSans();

  static const List<Map<String, Color>> colorPalette = [
    {'bg': Color(0xFFFEE2E2), 'text': Color(0xFFDC2626)}, // Red
    {'bg': Color(0xFFFFEDD5), 'text': Color(0xFFEA580C)}, // Orange
    {'bg': Color(0xFFFEF9C3), 'text': Color(0xFFCA8A04)}, // Yellow
    {'bg': Color(0xFFD1FAE5), 'text': Color(0xFF059669)}, // Emerald
    {'bg': Color(0xFFCCFBF1), 'text': Color(0xFF0D9488)}, // Teal
    {'bg': Color(0xFFE0F2FE), 'text': Color(0xFF0284C7)}, // Sky
    {'bg': Color(0xFFE0E7FF), 'text': Color(0xFF4F46E5)}, // Indigo
    {'bg': Color(0xFFF3E8FF), 'text': Color(0xFF9333EA)}, // Purple
    {'bg': Color(0xFFFAE8FF), 'text': Color(0xFFC026D3)}, // Fuchsia
    {'bg': Color(0xFFE2E8F0), 'text': Color(0xFF475569)}, // Slate
  ];
}