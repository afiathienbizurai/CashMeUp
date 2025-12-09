import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import 'categories_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool _pushNotification = true; // Default

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
  }

  // Load status notifikasi dari Firestore
  void _loadNotificationSetting() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          _pushNotification = doc.data()?['pushNotification'] ?? true;
        });
      }
    }
  }

  // Toggle notifikasi
  void _toggleNotification(bool value) async {
    setState(() => _pushNotification = value);
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'pushNotification': value});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgApp,
      appBar: AppBar(
        title: Text("Pengaturan", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppTheme.dark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // PROFILE CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
              child: Row(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(color: AppTheme.primarySoft, shape: BoxShape.circle, border: Border.all(color: Colors.indigo.shade100, width: 2)),
                    child: Center(child: Text(user?.displayName?.substring(0, 1).toUpperCase() ?? "U", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary))),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.displayName ?? "User", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? "", style: AppTheme.font.copyWith(fontSize: 12, color: AppTheme.muted)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // MENU PREFERENSI
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Text("PREFERENSI", style: AppTheme.font.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.muted)),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: FontAwesomeIcons.layerGroup, 
                        color: Colors.orange, 
                        title: "Manajemen Kategori", 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesPage())),
                      ),
                      const Divider(height: 1),
                      _buildToggleItem(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // TOMBOL LOGOUT
            TextButton(
              onPressed: () async {
                await context.read<AuthService>().signOut();
                if (mounted) Navigator.of(context).popUntil((route) => route.isFirst); // Kembali ke Root/Login
              },
              child: Text("Keluar Aplikasi", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, color: AppTheme.danger)),
            ),
            const SizedBox(height: 16),
            const Text("CashMeUp v1.0.0", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required Color color, required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Center(child: FaIcon(icon, size: 16, color: color)),
      ),
      title: Text(title, style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: AppTheme.muted),
    );
  }

  Widget _buildToggleItem() {
    return SwitchListTile(
      value: _pushNotification,
      onChanged: _toggleNotification,
      activeColor: AppTheme.success,
      title: Text("Push Notification", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
      secondary: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: const Center(child: FaIcon(FontAwesomeIcons.bell, size: 16, color: Colors.purple)),
      ),
    );
  }
}