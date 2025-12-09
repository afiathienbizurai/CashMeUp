import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/expense_chart.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime _currentDate = DateTime.now();

  // Logic Grafik (Tetap sama)
  List<double> _generateChartData(List<TransactionModel> transactions, DateTime date) {
    int days = DateUtils.getDaysInMonth(date.year, date.month);
    List<double> data = List.filled(days, 0.0);
    for (var tx in transactions) {
      if (tx.type == 'expense') data[tx.date.day - 1] += tx.amount.toDouble();
    }
    return data;
  }

  // LOGIC BARU: Mengembalikan List Object yang berisi Nama, Total, dan Warna
  List<Map<String, dynamic>> _calculateRanking(List<TransactionModel> transactions) {
    Map<String, double> amounts = {};
    Map<String, int> colors = {}; // Map untuk menyimpan warna kategori

    for (var tx in transactions) {
      if (tx.type == 'expense') {
        amounts[tx.category] = (amounts[tx.category] ?? 0) + tx.amount;
        // Ambil warna dari transaksi (asumsi semua kategori bernama sama punya warna sama)
        colors[tx.category] = tx.colorIdx; 
      }
    }

    // Ubah Map menjadi List agar mudah di-sort
    List<Map<String, dynamic>> result = [];
    amounts.forEach((key, value) {
      result.add({
        'name': key,
        'amount': value,
        'colorIdx': colors[key] ?? 0,
      });
    });

    // Sort dari pengeluaran terbesar
    result.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Laporan Keuangan", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Hapus tombol back karena ini Tab
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: context.watch<TransactionProvider>().transactionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final allTransactions = snapshot.data ?? [];
          final monthlyTransactions = allTransactions.where((t) => t.date.year == _currentDate.year && t.date.month == _currentDate.month).toList();

          double totalIncome = 0;
          double totalExpense = 0;
          for (var t in monthlyTransactions) {
            if (t.type == 'income') totalIncome += t.amount; else totalExpense += t.amount;
          }

          final chartData = _generateChartData(monthlyTransactions, _currentDate);
          // Panggil fungsi ranking yang baru
          final sortedCategories = _calculateRanking(monthlyTransactions);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // === HEADER BULAN ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => setState(() => _currentDate = DateTime(_currentDate.year, _currentDate.month - 1))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppTheme.bgApp), borderRadius: BorderRadius.circular(12)),
                      child: Text(DateFormat('MMMM yyyy', 'id_ID').format(_currentDate), style: AppTheme.font.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => setState(() => _currentDate = DateTime(_currentDate.year, _currentDate.month + 1))),
                  ],
                ),
                const SizedBox(height: 24),

                // === KARTU CHART UTAMA ===
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppTheme.bgApp), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("PENGELUARAN BULAN INI", style: AppTheme.font.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.muted)),
                      Text(formatter.format(totalExpense), style: AppTheme.font.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                      const SizedBox(height: 24),
                      ExpenseChart(dailyExpenses: chartData),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // === STATISTIK KECIL ===
                Row(
                  children: [
                    Expanded(child: _buildStatCard("Pemasukan", totalIncome, AppTheme.success, FontAwesomeIcons.arrowDown, formatter)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard("Pengeluaran", totalExpense, AppTheme.danger, FontAwesomeIcons.arrowUp, formatter)),
                  ],
                ),
                const SizedBox(height: 32),

                // === LIST PENGELUARAN TERBESAR ===
                Align(alignment: Alignment.centerLeft, child: Text("Pengeluaran Terbesar", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark))),
                const SizedBox(height: 16),
                
                if (sortedCategories.isEmpty) 
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Belum ada pengeluaran di bulan ini."),
                  ),

                // Loop semua kategori (tanpa limit)
                ...sortedCategories.map((data) {
                  final name = data['name'] as String;
                  final amount = data['amount'] as double;
                  final colorIdx = data['colorIdx'] as int;
                  
                  // Ambil warna tema berdasarkan colorIdx
                  final colorData = AppTheme.colorPalette[colorIdx % AppTheme.colorPalette.length];

                  double percent = totalExpense == 0 ? 0 : (amount / totalExpense);
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        // ICON KATEGORI (WARNA DINAMIS)
                        Container(
                          width: 40, height: 40, 
                          decoration: BoxDecoration(
                            color: colorData['bg'], // Background Warna Kategori
                            borderRadius: BorderRadius.circular(12)
                          ), 
                          child: Center(
                            child: Text(
                              name[0].toUpperCase(), 
                              style: TextStyle(fontWeight: FontWeight.bold, color: colorData['text']) // Text Warna Kategori
                            )
                          )
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              // ROW: NAMA KATEGORI & (NOMINAL + PERSEN)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                children: [
                                  Text(name, style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
                                  // Tampilkan Nominal dan Persen
                                  Row(
                                    children: [
                                      Text(
                                        formatter.format(amount), 
                                        style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.dark)
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "(${(percent * 100).toStringAsFixed(0)}%)", 
                                        style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.muted)
                                      ),
                                    ],
                                  )
                                ]
                              ),
                              const SizedBox(height: 6),
                              
                              // PROGRESS BAR (Warna mengikuti kategori juga agar cantik)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4), 
                                child: LinearProgressIndicator(
                                  value: percent, 
                                  minHeight: 8, 
                                  backgroundColor: AppTheme.bgApp, 
                                  valueColor: AlwaysStoppedAnimation<Color>(colorData['text']!) // Bar mengikuti warna kategori
                                )
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, double amount, Color color, IconData icon, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: FaIcon(icon, size: 12, color: Colors.white)),
          const SizedBox(height: 8),
          Text(title.toUpperCase(), style: AppTheme.font.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.muted)),
          const SizedBox(height: 4),
          Text(formatter.format(amount), style: AppTheme.font.copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.dark), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}