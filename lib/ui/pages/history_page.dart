import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/transaction_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _filterType = 'all';
  DateTime? _selectedDate;

  Map<String, List<TransactionModel>> _groupTransactions(List<TransactionModel> list) {
    Map<String, List<TransactionModel>> groups = {};
    for (var tx in list) {
      String dateKey = DateFormat('yyyy-MM-dd').format(tx.date);
      if (groups[dateKey] == null) groups[dateKey] = [];
      groups[dateKey]!.add(tx);
    }
    return groups;
  }

  String _getDateHeader(String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return "Hari Ini";
    if (checkDate == yesterday) return "Kemarin";
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Riwayat Transaksi", style: AppTheme.font.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.dark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: context.watch<TransactionProvider>().transactionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var transactions = snapshot.data ?? [];

          // Filtering
          if (_filterType != 'all') {
            transactions = transactions.where((t) => t.type == _filterType).toList();
          }
          if (_selectedDate != null) {
            transactions = transactions.where((t) => isSameDay(t.date, _selectedDate!)).toList();
          }

          final groupedTransactions = _groupTransactions(transactions);
          final sortedKeys = groupedTransactions.keys.toList()..sort((a, b) => b.compareTo(a));

          return Column(
            children: [
              // Filter Tabs
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.bgApp)),
                  child: Row(
                    children: [
                      _buildTab("Semua", 'all'),
                      _buildTab("Masuk", 'income'),
                      _buildTab("Keluar", 'expense'),
                    ],
                  ),
                ),
              ),

              // Date Header & Reset
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null ? "SEMUA WAKTU" : DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDate!).toUpperCase(),
                      style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.muted, letterSpacing: 1),
                    ),
                    Row(
                      children: [
                        if (_selectedDate != null)
                          IconButton(
                            icon: const Icon(Icons.close, size: 16, color: AppTheme.danger),
                            onPressed: () => setState(() => _selectedDate = null),
                          ),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
                            child: const Row(children: [FaIcon(FontAwesomeIcons.calendar, size: 14, color: AppTheme.primary), SizedBox(width: 8), Text("Filter", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Transaction List
              Expanded(
                child: transactions.isEmpty 
                  ? Center(child: Text("Tidak ada data", style: AppTheme.font.copyWith(color: AppTheme.muted)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: sortedKeys.length,
                      itemBuilder: (context, index) {
                        String dateKey = sortedKeys[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(_getDateHeader(dateKey).toUpperCase(), style: AppTheme.font.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.muted)),
                            ),
                            ...groupedTransactions[dateKey]!.map((tx) => TransactionCard(transaction: tx)),
                          ],
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab(String label, String value) {
    bool isActive = _filterType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filterType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: isActive ? AppTheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(label, style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.white : AppTheme.muted))),
        ),
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}