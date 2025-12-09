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

  List<double> _generateChartData(List<TransactionModel> transactions, DateTime date) {
    int days = DateUtils.getDaysInMonth(date.year, date.month);
    List<double> data = List.filled(days, 0.0);
    for (var tx in transactions) {
      if (tx.type == 'expense') data[tx.date.day - 1] += tx.amount.toDouble();
    }
    return data;
  }

  Map<String, double> _calculateRanking(List<TransactionModel> transactions) {
    Map<String, double> totals = {};
    for (var tx in transactions) {
      if (tx.type == 'expense') totals[tx.category] = (totals[tx.category] ?? 0) + tx.amount;
    }
    return totals;
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
        leading: const BackButton(color: AppTheme.dark),
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
          final sortedCategories = _calculateRanking(monthlyTransactions).entries.toList()..sort((a, b) => b.value.compareTo(a.value));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
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

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppTheme.bgApp), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pengeluaran Bulan Ini".toUpperCase(), style: AppTheme.font.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.muted)),
                      Text(formatter.format(totalExpense), style: AppTheme.font.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                      const SizedBox(height: 24),
                      ExpenseChart(dailyExpenses: chartData),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(child: _buildStatCard("Pemasukan", totalIncome, AppTheme.success, FontAwesomeIcons.arrowDown, formatter)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard("Pengeluaran", totalExpense, AppTheme.danger, FontAwesomeIcons.arrowUp, formatter)),
                  ],
                ),
                const SizedBox(height: 32),

                Align(alignment: Alignment.centerLeft, child: Text("Pengeluaran Terbesar", style: AppTheme.font.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.dark))),
                const SizedBox(height: 16),
                
                if (sortedCategories.isEmpty) const Text("Belum ada pengeluaran."),

                ...sortedCategories.map((entry) {
                  double percent = totalExpense == 0 ? 0 : (entry.value / totalExpense);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(entry.key[0], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700)))),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(entry.key, style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 12)), Text("${(percent * 100).toStringAsFixed(0)}%", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 12))]),
                              const SizedBox(height: 6),
                              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: percent, minHeight: 8, backgroundColor: AppTheme.bgApp, valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue))),
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