import 'package:flutter/material.dart';

class ReportHeaderChart extends StatefulWidget {
  const ReportHeaderChart({super.key});

  @override
  State<ReportHeaderChart> createState() => _ReportHeaderChartState();
}

class _ReportHeaderChartState extends State<ReportHeaderChart> {
  int selectedTab = 0;
  final List<String> tabs = ["Weekly", "Monthly", "Yearly"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffe9f1ff),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          /// TABS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              tabs.length,
              (i) => GestureDetector(
                onTap: () => setState(() => selectedTab = i),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedTab == i
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectedTab == i
                          ? Colors.black
                          : Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// CHART UI (dummy untuk UI dulu)
          SizedBox(
            height: 160,
            child: Image.asset(
              "assets/images/example_chart.png",
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 12),
                  SizedBox(width: 5),
                  Text("Rp12.000"),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.red, size: 12),
                  SizedBox(width: 5),
                  Text("-Rp10.000"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
