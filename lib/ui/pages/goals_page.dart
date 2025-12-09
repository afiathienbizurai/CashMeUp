import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme.dart';
import '../../models/goal_model.dart';
import '../../providers/goal_provider.dart';
import '../widgets/primary_button.dart';
import 'add_goal_page.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  String formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Goals & Impian", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Karena ini Tab Utama
        // Tombol Tambah di AppBar DIHAPUS sesuai permintaan
      ),
      body: StreamBuilder<List<GoalModel>>(
        stream: context.watch<GoalProvider>().getGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final goals = snapshot.data ?? [];

          // EMPTY STATE
          if (goals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.bullseye, size: 40, color: AppTheme.muted),
                    const SizedBox(height: 16),
                    Text("Belum ada goals", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: "Buat Goal Pertama", 
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGoalPage())),
                    ),
                  ],
                ),
              ),
            );
          }

          final featuredGoal = goals.first;
          final otherGoals = goals.skip(1).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === FEATURED GOAL (Klik untuk Edit) ===
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddGoalPage(goalToEdit: featuredGoal))),
                  child: _buildFeaturedGoal(featuredGoal)
                ),
                const SizedBox(height: 32),

                // === HEADER LIST & TOMBOL TAMBAH ===
                // Tombol tambah sekarang ada di SINI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Goals Lainnya", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                    
                    // TOMBOL TAMBAH (Kecil di sebelah text)
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGoalPage())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primarySoft, 
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.plus, size: 12, color: AppTheme.primary),
                            const SizedBox(width: 6),
                            Text("Tambah", style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                
                // === LIST GOALS KECIL (Klik untuk Edit) ===
                ...otherGoals.map((g) => GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddGoalPage(goalToEdit: g))),
                  child: _buildGoalItem(context, g)
                )),
                
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedGoal(GoalModel goal) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Jika selesai, ubah background jadi Hijau Gelap, jika belum Hitam/Dark
        color: goal.isCompleted ? AppTheme.success : AppTheme.dark,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: (goal.isCompleted ? AppTheme.success : AppTheme.dark).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(goal.title, style: AppTheme.font.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    if (goal.isCompleted)
                      const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.check_circle, color: Colors.white, size: 20))
                  ],
                ),
                const SizedBox(height: 4),
                Text("Target: ${formatRupiah(goal.targetAmount)}", style: AppTheme.font.copyWith(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 12),
                Text(
                  goal.isCompleted ? "Tercapai!" : "Terkumpul: ${formatRupiah(goal.currentAmount)}", 
                  style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ],
            ),
          ),
          SizedBox(
            width: 64, height: 64,
            child: Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(
                    value: goal.progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Center(
                  child: Text("${goal.percent}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGoalItem(BuildContext context, GoalModel goal) {
    final colors = AppTheme.colorPalette[goal.colorIdx];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Inisial (Tanpa Icon)
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: goal.isCompleted ? AppTheme.success.withOpacity(0.1) : colors['bg'], 
              borderRadius: BorderRadius.circular(16)
            ),
            child: Center(
              child: goal.isCompleted
                ? const Icon(Icons.check, color: AppTheme.success)
                : Text(goal.title.isNotEmpty ? goal.title[0].toUpperCase() : 'G', style: TextStyle(color: colors['text'], fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.title, style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: goal.progress,
                    backgroundColor: Colors.grey.shade100,
                    // Jika selesai warna hijau, jika belum ikut warna kategori
                    valueColor: AlwaysStoppedAnimation<Color>(goal.isCompleted ? AppTheme.success : colors['text']!),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  goal.isCompleted ? "Selesai" : "Terkumpul ${formatRupiah(goal.currentAmount)}", 
                  style: TextStyle(fontSize: 10, color: goal.isCompleted ? AppTheme.success : AppTheme.muted, fontWeight: goal.isCompleted ? FontWeight.bold : FontWeight.normal)
                ),
              ],
            ),
          ),
          
          // ICON PENSIL SUDAH DIHAPUS (Sekarang seluruh kartu bisa diklik)
          const Icon(Icons.chevron_right, size: 16, color: AppTheme.muted),
        ],
      ),
    );
  }
}