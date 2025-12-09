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
  String _reportType = 'expense'; // State untuk toggle (income/expense)

  // LOGIC GRAFIK: Filter berdasarkan tipe
  List<double> _generateChartData(List<TransactionModel> transactions, DateTime date, String type) {
    int days = DateUtils.getDaysInMonth(date.year, date.month);
    List<double> data = List.filled(days, 0.0);
    
    for (var tx in transactions) {
      // Hanya masukkan data sesuai tipe yang dipilih (expense/income)
      if (tx.type == type) {
        data[tx.date.day - 1] += tx.amount.toDouble();
      }
    }
    return data;
  }

  // LOGIC RANKING: Filter berdasarkan tipe
  List<Map<String, dynamic>> _calculateRanking(List<TransactionModel> transactions, String type) {
    Map<String, double> amounts = {};
    Map<String, int> colors = {};

    for (var tx in transactions) {
      if (tx.type == type) {
        amounts[tx.category] = (amounts[tx.category] ?? 0) + tx.amount;
        colors[tx.category] = tx.colorIdx; 
      }
    }

    List<Map<String, dynamic>> result = [];
    amounts.forEach((key, value) {
      result.add({
        'name': key,
        'amount': value,
        'colorIdx': colors[key] ?? 0,
      });
    });

    result.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // Tentukan warna tema berdasarkan tipe laporan
    final Color themeColor = _reportType == 'expense' ? AppTheme.danger : AppTheme.success;
    final String titleLabel = _reportType == 'expense' ? "Pengeluaran" : "Pemasukan";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Laporan Keuangan", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: context.watch<TransactionProvider>().transactionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final allTransactions = snapshot.data ?? [];
          
          // 1. Filter Data Bulan Ini
          final monthlyTransactions = allTransactions.where((t) => t.date.year == _currentDate.year && t.date.month == _currentDate.month).toList();

          // 2. Hitung Total (Untuk Statistik Kecil)
          double totalIncome = 0;
          double totalExpense = 0;
          for (var t in monthlyTransactions) {
            if (t.type == 'income') totalIncome += t.amount; else totalExpense += t.amount;
          }

          // 3. Tentukan Total Utama yang ditampilkan di Chart berdasarkan Toggle
          double currentTotal = _reportType == 'expense' ? totalExpense : totalIncome;

          // 4. Generate Data Chart & Ranking berdasarkan Toggle
          final chartData = _generateChartData(monthlyTransactions, _currentDate, _reportType);
          final sortedCategories = _calculateRanking(monthlyTransactions, _reportType);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // === HEADER NAVIGASI & TOGGLE ===
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Navigasi Tanggal
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.chevron_left, color: AppTheme.dark), 
                            onPressed: () => setState(() => _currentDate = DateTime(_currentDate.year, _currentDate.month - 1))
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMMM yyyy', 'id_ID').format(_currentDate), 
                            style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 14)
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.chevron_right, color: AppTheme.dark), 
                            onPressed: () => setState(() => _currentDate = DateTime(_currentDate.year, _currentDate.month + 1))
                          ),
                        ],
                      ),

                      // Toggle Button (Expense / Income)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildToggleIcon(Icons.arrow_upward, 'expense', AppTheme.danger),
                            const SizedBox(width: 4),
                            _buildToggleIcon(Icons.arrow_downward, 'income', AppTheme.success),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // === KARTU CHART UTAMA ===
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(24), 
                    border: Border.all(color: AppTheme.bgApp), 
                    boxShadow: [BoxShadow(color: themeColor.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$titleLabel Bulan Ini".toUpperCase(), style: AppTheme.font.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.muted)),
                          Icon(_reportType == 'expense' ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown, size: 14, color: themeColor),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(formatter.format(currentTotal), style: AppTheme.font.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                      const SizedBox(height: 24),
                      // Pass warna tema ke Chart
                      ExpenseChart(dailyExpenses: chartData, chartColor: themeColor),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // === STATISTIK KECIL (Tetap menampilkan keduanya untuk info) ===
                Row(
                  children: [
                    Expanded(child: _buildStatCard("Pemasukan", totalIncome, AppTheme.success, FontAwesomeIcons.arrowDown, formatter)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard("Pengeluaran", totalExpense, AppTheme.danger, FontAwesomeIcons.arrowUp, formatter)),
                  ],
                ),
                const SizedBox(height: 32),

                // === LIST KATEGORI TERBESAR ===
                Align(alignment: Alignment.centerLeft, child: Text("$titleLabel Terbesar", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark))),
                const SizedBox(height: 16),
                
                if (sortedCategories.isEmpty) 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text("Belum ada data $titleLabel di bulan ini.", style: const TextStyle(color: AppTheme.muted)),
                  ),

                // Loop semua kategori
                ...sortedCategories.map((data) {
                  final name = data['name'] as String;
                  final amount = data['amount'] as double;
                  final colorIdx = data['colorIdx'] as int;
                  final colorData = AppTheme.colorPalette[colorIdx % AppTheme.colorPalette.length];

                  double percent = currentTotal == 0 ? 0 : (amount / currentTotal);
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        // ICON KATEGORI
                        Container(
                          width: 40, height: 40, 
                          decoration: BoxDecoration(color: colorData['bg'], borderRadius: BorderRadius.circular(12)), 
                          child: Center(child: Text(name[0].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: colorData['text'])))
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                children: [
                                  Text(name, style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
                                  Row(
                                    children: [
                                      Text(formatter.format(amount), style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.dark)),
                                      const SizedBox(width: 4),
                                      Text("(${(percent * 100).toStringAsFixed(0)}%)", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.muted)),
                                    ],
                                  )
                                ]
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4), 
                                child: LinearProgressIndicator(
                                  value: percent, 
                                  minHeight: 8, 
                                  backgroundColor: AppTheme.bgApp, 
                                  // Progress bar warnanya mengikuti tema toggle (Merah/Hijau) agar jelas ini income/expense
                                  valueColor: AlwaysStoppedAnimation<Color>(themeColor) 
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

  // Widget Tombol Toggle Kecil
  Widget _buildToggleIcon(IconData icon, String type, Color color) {
    bool isSelected = _reportType == type;
    return GestureDetector(
      onTap: () => setState(() => _reportType = type),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
        ),
        child: Icon(icon, size: 20, color: isSelected ? color : AppTheme.muted),
      ),
    );
  }

  Widget _buildStatCard(String title, double amount, Color color, IconData icon, NumberFormat formatter) {
    // Opacity dikurangi jika tidak sedang dipilih, agar user fokus ke tipe yg aktif
    bool isActive = (_reportType == 'expense' && title == "Pengeluaran") || (_reportType == 'income' && title == "Pemasukan");
    double opacity = isActive ? 1.0 : 0.5;

    return Opacity(
      opacity: opacity,
      child: Container(
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
      ),
    );
  }
}