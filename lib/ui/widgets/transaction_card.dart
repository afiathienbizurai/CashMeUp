import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Butuh provider untuk panggil fungsi delete
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // BUNGKUS DENGAN DISMISSIBLE
    return Dismissible(
      key: Key(transaction.id), // Key wajib unik agar Flutter tau item mana yang digeser
      direction: DismissDirection.endToStart, // Geser dari Kanan ke Kiri
      
      // Background saat digeser (Warna Merah & Icon Sampah)
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.danger,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const FaIcon(FontAwesomeIcons.trashCan, color: Colors.white),
      ),
      
      // Dialog Konfirmasi sebelum hapus
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Hapus Transaksi?"),
            content: const Text("Data yang dihapus tidak bisa dikembalikan."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false), // Batal
                child: const Text("Batal", style: TextStyle(color: AppTheme.muted)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true), // Ya, Hapus
                child: const Text("Hapus", style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },

      // Aksi jika user menekan "Hapus"
      onDismissed: (direction) {
        // Panggil Provider untuk hapus data di Firebase
        context.read<TransactionProvider>().deleteTransaction(transaction.id);
        
        // Opsional: Tampilkan feedback snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaksi dihapus"), duration: Duration(seconds: 1)),
        );
      },

      // UI KARTU TRANSAKSI (Code Lama)
      child: Container(
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
            Text(
              "${isIncome ? '+' : '-'} ${formatter.format(transaction.amount)}",
              style: AppTheme.font.copyWith(
                fontSize: 14, 
                fontWeight: FontWeight.bold,
                color: isIncome ? AppTheme.success : AppTheme.danger
              ),
            ),
          ],
        ),
      ),
    );
  }
}