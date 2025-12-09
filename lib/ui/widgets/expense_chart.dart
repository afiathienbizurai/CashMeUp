import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ExpenseChart extends StatelessWidget {
  final List<double> dailyExpenses; // Data pengeluaran tgl 1 - 30/31

  const ExpenseChart({super.key, required this.dailyExpenses});

  @override
  Widget build(BuildContext context) {
    // Cari nilai tertinggi untuk menentukan batas atas grafik
    double maxY = dailyExpenses.reduce((curr, next) => curr > next ? curr : next);
    if (maxY == 0) maxY = 100; // Default jika belum ada data

    return AspectRatio(
      aspectRatio: 1.70,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false), // Matikan grid biar clean
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 5, // Tampilkan angka setiap 5 hari (Tgl 1, 6, 11..)
                getTitlesWidget: (value, meta) {
                  int tgl = value.toInt() + 1;
                  // Jangan tampilkan jika melebihi jumlah hari
                  if (tgl > dailyExpenses.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      tgl.toString(),
                      style: AppTheme.font.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.muted),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: dailyExpenses.length.toDouble() - 1,
          minY: 0,
          maxY: maxY * 1.2, // Tambahkan ruang 20% di atas
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(dailyExpenses.length, (index) {
                return FlSpot(index.toDouble(), dailyExpenses[index]);
              }),
              isCurved: true,
              color: AppTheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.3),
                    AppTheme.primary.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          // Interaksi saat disentuh
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppTheme.primary,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  return LineTooltipItem(
                    'Rp ${touchedSpot.y.toInt()}',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}