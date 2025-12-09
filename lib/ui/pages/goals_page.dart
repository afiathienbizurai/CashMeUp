import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme.dart';
import '../../models/goal_model.dart';
import '../../providers/goal_provider.dart';
import '../widgets/primary_button.dart'; // Pastikan import ini ada
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.dark),
          onPressed: () => Navigator.pop(context),
        ),
        // PERBAIKAN 1: Tombol Tambah selalu muncul di Header
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGoalPage())),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.bgApp, borderRadius: BorderRadius.circular(12)),
              child: const FaIcon(FontAwesomeIcons.plus, size: 14, color: AppTheme.dark),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<List<GoalModel>>(
        stream: context.watch<GoalProvider>().getGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final goals = snapshot.data ?? [];

          // PERBAIKAN 2: Tampilan Empty State yang lebih jelas
          if (goals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: AppTheme.primarySoft, shape: BoxShape.circle),
                      child: const Center(child: FaIcon(FontAwesomeIcons.bullseye, size: 32, color: AppTheme.primary)),
                    ),
                    const SizedBox(height: 24),
                    Text("Belum ada goals", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                    const SizedBox(height: 8),
                    Text("Yuk mulai wujudkan impianmu dengan menabung sedikit demi sedikit.", textAlign: TextAlign.center, style: AppTheme.font.copyWith(color: AppTheme.muted)),
                    const SizedBox(height: 32),
                    // Tombol Besar (Call to Action)
                    PrimaryButton(
                      text: "Buat Goal Pertama", 
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGoalPage())),
                    ),
                  ],
                ),
              ),
            );
          }

          // Pisahkan Goal Utama (Paling baru/prioritas) dan Goal Lainnya
          final featuredGoal = goals.first;
          final otherGoals = goals.skip(1).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === FEATURED GOAL (KARTU HITAM BESAR) ===
                _buildFeaturedGoal(featuredGoal),
                const SizedBox(height: 32),

                // === HEADER LIST ===
                // Jika goals > 1, tampilkan tulisan "Lainnya"
                if (otherGoals.isNotEmpty) ...[
                  Text("Goals Lainnya", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                  const SizedBox(height: 16),
                  
                  // === LIST GOALS KECIL ===
                  ...otherGoals.map((g) => _buildGoalItem(context, g)),
                ],
                
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
        color: AppTheme.dark,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: AppTheme.dark.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.title, style: AppTheme.font.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text("Target: ${formatRupiah(goal.targetAmount)}", style: AppTheme.font.copyWith(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 12),
                Text("Terkumpul: ${formatRupiah(goal.currentAmount)}", style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          // Circular Progress
          SizedBox(
            width: 64, height: 64,
            child: Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(
                    value: goal.progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
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
            decoration: BoxDecoration(color: colors['bg'], borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Text(goal.title.isNotEmpty ? goal.title[0].toUpperCase() : 'G', style: TextStyle(color: colors['text'], fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.title, style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                // Progress Bar Garis
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: goal.progress,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(colors['text']!),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Terkumpul ${formatRupiah(goal.currentAmount)}", style: const TextStyle(fontSize: 10, color: AppTheme.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          
          // Tombol Edit (Kecil) -> Untuk menabung
          IconButton(
            icon: const Icon(Icons.edit, size: 16, color: AppTheme.muted),
            onPressed: () {
               _showUpdateDialog(context, goal);
            },
          )
        ],
      ),
    );
  }

  // Dialog Cepat Update Tabungan
  void _showUpdateDialog(BuildContext context, GoalModel goal) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Update Tabungan: ${goal.title}"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Masukkan Saldo Baru (Total)"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text) ?? goal.currentAmount;
              ctx.read<GoalProvider>().updateGoal(goal.id, val);
              Navigator.pop(ctx);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}