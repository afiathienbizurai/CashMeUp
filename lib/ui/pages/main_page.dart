import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';

// Import semua halaman yang akan jadi Tab
import 'home_page.dart';
import 'history_page.dart';
import 'goals_page.dart';
import 'report_page.dart';
import 'add_transaction_page.dart'; // Import halaman Add

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Menyimpan status tab mana yang aktif (0 = Home)

  // Daftar Halaman yang akan ditampilkan di Body
  // Perhatikan urutannya harus sesuai dengan icon di Navbar
  final List<Widget> _pages = [
    const HomePage(),
    const HistoryPage(),
    const SizedBox(), // Placeholder untuk tombol tengah (Add)
    const GoalsPage(),
    const ReportPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgApp,
      
      // BODY: Menampilkan halaman sesuai index yang dipilih
      // Menggunakan IndexedStack agar halaman tidak ter-reset saat pindah tab
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // NAVBAR PERSISTEN
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, FontAwesomeIcons.house, "Home"),
            _buildNavItem(1, FontAwesomeIcons.receipt, "History"),
            
            // TOMBOL ADD (TENGAH) - Logic Khusus
            GestureDetector(
              onTap: () {
                // Saat tombol Add ditekan, jangan ganti Tab, tapi Push halaman baru
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTransactionPage()),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 20),
                ),
              ),
            ),

            _buildNavItem(3, FontAwesomeIcons.bullseye, "Goals"),
            _buildNavItem(4, FontAwesomeIcons.chartPie, "Report"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon, 
            size: 20, 
            color: isActive ? AppTheme.primary : AppTheme.muted
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.font.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? AppTheme.primary : AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}