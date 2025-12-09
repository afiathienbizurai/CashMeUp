import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/market_widget.dart';
import 'add_transaction_page.dart'; 
import 'history_page.dart';
import 'goals_page.dart';
import 'report_page.dart';
import 'settings_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Ambil user yang sedang login untuk ditampilkan namanya
  final User? user = FirebaseAuth.instance.currentUser;

  // Fungsi helper untuk format Rupiah
  String formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
    void initState() {
      super.initState();
      
      // SETUP LISTENER NOTIFIKASI (FOREGROUND)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          // Tampilkan Snackbar jika ada pesan masuk
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.primary,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.notification!.title ?? 'Notifikasi Baru',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(message.notification!.body ?? ''),
                ],
              ),
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating, // Melayang di atas
              margin: const EdgeInsets.all(20), // Jarak dari pinggir
            ),
          );
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    // TransactionProvider sudah kita setup di main.dart
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.bgApp,
      // HEADER
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            // Avatar Inisial User
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
                  "Haii, ${user?.displayName?.split(' ')[0] ?? 'User'}! 👋",
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
                
                // Indikator Merah (Dot) - Cek Realtime jika ada yang unread
                // Kita gunakan StreamBuilder kecil di sini khusus untuk badge
                Positioned(
                  right: 0,
                  top: 0,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('notifications')
                        .where('isRead', isEqualTo: false) // Hanya cari yang belum dibaca
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
                      return const SizedBox(); // Tidak ada dot jika semua sudah dibaca
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // TOMBOL SETTINGS (Yang sudah ada sebelumnya)
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
      
      // BODY: Menggunakan StreamBuilder agar data REALTIME dari Firebase
      body: StreamBuilder<List<TransactionModel>>(
        stream: transactionProvider.transactionStream, // Mendengarkan stream dari Provider
        builder: (context, snapshot) {
          
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error State
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // 3. Data Ready
          final transactions = snapshot.data ?? [];
          
          // LOGIC HITUNG SALDO (Client Side Calculation)
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

                // === RECENT TRANSACTIONS ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Transaksi Terbaru", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                    TextButton(onPressed: () {}, child: Text("Lihat Semua", style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary))),
                  ],
                ),
                const SizedBox(height: 16),

                // List Transaksi (Ambil 5 teratas saja untuk Home)
                ...transactions.take(5).map((t) => _buildTransactionItem(t)),
                
                if (transactions.isEmpty) 
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Belum ada transaksi", style: AppTheme.font.copyWith(color: AppTheme.muted)),
                  ),
                const SizedBox(height: 32),

                const MarketWidget(),

                const SizedBox(height: 100), 
              ],
            ),
          );
        },
      ),

      // BOTTOM NAVIGATION (Sederhana dulu, nanti dipisah)
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade100))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(FontAwesomeIcons.house, "Home", true),

            _buildNavItem(
              FontAwesomeIcons.receipt, 
              "History", 
              false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),

            GestureDetector(
              onTap: () {
                // Panggil Halaman AddTransactionPage
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const AddTransactionPage())
                );
              },
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary, 
                  borderRadius: BorderRadius.circular(16)
                ),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 20)
                ),
              ),
            ),
            _buildNavItem(
              FontAwesomeIcons.bullseye, 
              "Goals", 
              false,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GoalsPage()));
              },
            ),
            _buildNavItem(
              FontAwesomeIcons.chartPie, 
              "Report", 
              false,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET KECIL (HELPER)
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

  Widget _buildTransactionItem(TransactionModel t) {
    final isIncome = t.type == 'income';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade50),
      ),
      child: Row(
        children: [
          // Inisial Huruf (Pengganti Icon)
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: isIncome ? AppTheme.success.withOpacity(0.1) : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                t.title.isNotEmpty ? t.title[0].toUpperCase() : "?",
                style: AppTheme.font.copyWith(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: isIncome ? AppTheme.success : Colors.blue.shade600
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: AppTheme.font.copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                const SizedBox(height: 2),
                Text(t.category, style: AppTheme.font.copyWith(fontSize: 11, color: AppTheme.muted)),
              ],
            ),
          ),
          Text(
            "${isIncome ? '+' : '-'} ${formatRupiah(t.amount)}",
            style: AppTheme.font.copyWith(
              fontSize: 14, 
              fontWeight: FontWeight.bold,
              color: isIncome ? AppTheme.success : AppTheme.dark // Expense warna hitam sesuai desain
            ),
          ),
        ],
      ),
    );
  }

  // Tambahkan parameter '{VoidCallback? onTap}' agar tombol bisa menerima fungsi klik
  Widget _buildNavItem(IconData icon, String label, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // Pasang fungsi klik di sini
      behavior: HitTestBehavior.opaque, // Agar area kosong di sekitar icon juga bisa diklik
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: 20, color: isActive ? AppTheme.primary : AppTheme.muted),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.font.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? AppTheme.primary : AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}