import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ExpenseChart extends StatelessWidget {
  final List<double> dailyExpenses;
  final Color chartColor; // <--- Parameter Baru

  const ExpenseChart({
    super.key, 
    required this.dailyExpenses,
    required this.chartColor, // Wajib diisi
  });

  @override
  Widget build(BuildContext context) {
    double maxY = dailyExpenses.isEmpty 
        ? 100 
        : dailyExpenses.reduce((curr, next) => curr > next ? curr : next);
    if (maxY == 0) maxY = 100;

    return AspectRatio(
      aspectRatio: 1.70,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  int tgl = value.toInt() + 1;
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
          maxY: maxY * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(dailyExpenses.length, (index) {
                return FlSpot(index.toDouble(), dailyExpenses[index]);
              }),
              isCurved: true,
              color: chartColor, // <--- Gunakan warna parameter
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    chartColor.withOpacity(0.3),
                    chartColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => chartColor, // Tooltip ikut warna chart
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