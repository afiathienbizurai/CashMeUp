import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cashmeup/features/home/home_page.dart';
import 'package:cashmeup/features/history/history_page.dart';
import 'package:cashmeup/features/goals/goals_page.dart';
import 'package:cashmeup/features/report/report_page.dart';
import 'package:cashmeup/core/providers/nav_provider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavProvider>(context);

    final pages = [
      const HomePage(),
      const HistoryPage(),
      const SizedBox(), // middle button placeholder
      const GoalsPage(),
      const ReportPage(),
    ];

    return Scaffold(
      body: pages[nav.index],
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        children: [
          BottomNavigationBar(
            currentIndex: nav.index,
            onTap: (i) {
              if (i == 2) return; // middle button tidak pindah halaman
              nav.setIndex(i);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
            ],
            type: BottomNavigationBarType.fixed,
          ),

          /// TOMBOL BULAT DI TENGAH
          Positioned(
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                // TODO: Open Add Transaction Page
              },
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                    )
                  ]
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
