import 'package:flutter/material.dart';

class ReportSummaryCards extends StatelessWidget {
  const ReportSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        summaryCard(
          icon: Icons.arrow_downward,
          title: "Total Pemasukan",
          value: "Rp 12.000.000,00",
          color: const Color(0xffd7f8db),
        ),
        const SizedBox(height: 12),
        summaryCard(
          icon: Icons.arrow_upward,
          title: "Total Pengeluaran",
          value: "Rp ---",
          color: const Color(0xffdae9ff),
        ),
        const SizedBox(height: 12),
        summaryCard(
          icon: Icons.account_balance_wallet,
          title: "Total Saldo",
          value: "Rp ---",
          color: const Color(0xfff4dfff),
        ),
      ],
    );
  }

  Widget summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
