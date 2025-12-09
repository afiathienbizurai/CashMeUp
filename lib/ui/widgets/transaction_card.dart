import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade50),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Inisial / Icon
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: isIncome ? AppTheme.success.withOpacity(0.1) : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                transaction.title.isNotEmpty ? transaction.title[0].toUpperCase() : "?",
                style: AppTheme.font.copyWith(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: isIncome ? AppTheme.success : Colors.blue.shade600
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Judul & Kategori
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTheme.font.copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.dark)),
                const SizedBox(height: 2),
                Text(transaction.category, style: AppTheme.font.copyWith(fontSize: 11, color: AppTheme.muted)),
              ],
            ),
          ),
          // Nominal
          Text(
            "${isIncome ? '+' : '-'} ${formatter.format(transaction.amount)}",
            style: AppTheme.font.copyWith(
              fontSize: 14, 
              fontWeight: FontWeight.bold,
              color: isIncome ? AppTheme.success : AppTheme.danger // Merah untuk pengeluaran sesuai desain HTML
            ),
          ),
        ],
      ),
    );
  }
}