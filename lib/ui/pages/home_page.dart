import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/market_widget.dart';
import '../widgets/transaction_card.dart'; 
import 'notification_page.dart';
import 'settings_page.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  String formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    String displayName = user?.displayName ?? user?.email?.split('@')[0] ?? "User";
    if (displayName.isNotEmpty) {
      displayName = displayName[0].toUpperCase() + displayName.substring(1);
    }

    return Scaffold(
      backgroundColor: AppTheme.bgApp,
      // HEADER (APP BAR)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false, // Hapus tombol back karena ini Tab Utama
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Center(
                child: Text(
                  user?.displayName?.substring(0, 1).toUpperCase() ?? "U",
                  style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Haii, $displayName! 👋",
                  style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark),
                ),
                Text(
                  "Atur keuanganmu hari ini",
                  style: AppTheme.font.copyWith(fontSize: 12, color: AppTheme.muted),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // TOMBOL NOTIFIKASI
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()));
            },
            icon: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white, 
                    shape: BoxShape.circle
                  ),
                  child: const FaIcon(FontAwesomeIcons.bell, size: 20, color: AppTheme.dark),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('notifications')
                        .where('isRead', isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        return Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.danger,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // TOMBOL SETTINGS
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const FaIcon(FontAwesomeIcons.gear, size: 20, color: AppTheme.dark),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      
      // BODY
      body: StreamBuilder<List<TransactionModel>>(
        stream: transactionProvider.transactionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final transactions = snapshot.data ?? [];
          
          // Logic Saldo
          int pemasukan = 0;
          int pengeluaran = 0;
          for (var t in transactions) {
            if (t.type == 'income') {
              pemasukan += t.amount;
            } else {
              pengeluaran += t.amount;
            }
          }
          int saldo = pemasukan - pengeluaran;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // === SALDO SECTION ===
                Text("Total Saldo Aktif", style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.muted, letterSpacing: 1)),
                const SizedBox(height: 8),
                Text(
                  formatRupiah(saldo),
                  style: AppTheme.font.copyWith(fontSize: 40, fontWeight: FontWeight.w800, color: AppTheme.dark),
                ),
                const SizedBox(height: 32),

                // === SUMMARY CARDS ===
                Row(
                  children: [
                    _buildSummaryCard("Pemasukan", pemasukan, AppTheme.success, FontAwesomeIcons.arrowDown),
                    const SizedBox(width: 16),
                    _buildSummaryCard("Pengeluaran", pengeluaran, AppTheme.danger, FontAwesomeIcons.arrowUp),
                  ],
                ),
                const SizedBox(height: 32),

                // === RECENT TRANSACTIONS HEADER ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Transaksi Terbaru", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                    // TextButton(
                    //   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage())),
                    //   child: Text("Lihat Semua", style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary))
                    // ),
                  ],
                ),
                const SizedBox(height: 16),

                // === LIST TRANSAKSI TERBARU (Updated) ===
                // Sekarang menggunakan TransactionCard agar warnanya sinkron dengan History Page
                ...transactions.take(5).map((t) => TransactionCard(transaction: t)),
                
                if (transactions.isEmpty) 
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Belum ada transaksi", style: AppTheme.font.copyWith(color: AppTheme.muted)),
                  ),
                  
                const SizedBox(height: 32),
                
                // === MARKET WIDGETS ===
                const MarketWidget(),

                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, int amount, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 128,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Center(child: FaIcon(icon, size: 14, color: color)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.toUpperCase(), style: AppTheme.font.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.muted)),
                const SizedBox(height: 4),
                Text(formatRupiah(amount), style: AppTheme.font.copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.dark)),
              ],
            )
          ],
        ),
      ),
    );
  }
} 