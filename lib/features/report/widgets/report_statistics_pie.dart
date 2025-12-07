import 'package:flutter/material.dart';

class ReportStatisticsPie extends StatelessWidget {
  const ReportStatisticsPie({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // PIE CHART
        SizedBox(
          height: 160,
          width: 160,
          child: Image.asset("assets/images/example_pie.png"),
        ),

        const SizedBox(width: 20),

        // LEGENDS
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            legend("Transport", Colors.blue),
            legend("Hiburan", Colors.orange),
            legend("Makanan & Minuman", Colors.yellow),
            legend("Listrik", Colors.red),
            legend("Lainnya", Colors.grey),
          ],
        )
      ],
    );
  }

  static Widget legend(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 12),
          SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
