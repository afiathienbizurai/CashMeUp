import 'package:flutter/material.dart';

class ReportStatisticsBar extends StatefulWidget {
  const ReportStatisticsBar({super.key});

  @override
  State<ReportStatisticsBar> createState() => _ReportStatisticsBarState();
}

class _ReportStatisticsBarState extends State<ReportStatisticsBar> {
  int selected = 0;
  final tabs = ["Weekly", "Monthly", "Yearly"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// TABS
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: List.generate(
            tabs.length,
            (i) => GestureDetector(
              onTap: () => setState(() => selected = i),
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      selected == i ? const Color(0xffe9e1ff) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        selected == i ? Colors.deepPurple : Colors.black45,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// BAR CHART DUMMY
        Column(
          children: List.generate(
            5,
            (_) => barItem("Transport", "20%"),
          ),
        ),
      ],
    );
  }

  Widget barItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          Container(
            height: 14,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.2, // 20%
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
