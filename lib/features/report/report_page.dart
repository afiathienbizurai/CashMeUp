import 'package:flutter/material.dart';
import 'widgets/report_header_chart.dart';
import 'widgets/report_summary_cards.dart';
import 'widgets/report_statistics_pie.dart';
import 'widgets/report_statistics_bar.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Report",
                    style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// LINE CHART + TAB (Weekly / Monthly / Yearly)
              const ReportHeaderChart(),

              const SizedBox(height: 20),

              /// SUMMARY CARDS (3 kotak di kanan)
              const ReportSummaryCards(),

              const SizedBox(height: 25),

              const Text(
                "Statistics",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// PIE CHART
              const ReportStatisticsPie(),

              const SizedBox(height: 25),

              /// BAR CHART (Weekly / Monthly / Yearly)
              const ReportStatisticsBar(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
