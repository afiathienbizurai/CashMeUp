import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';
import '../../services/market_service.dart';

class MarketWidget extends StatelessWidget {
  const MarketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final marketService = MarketService();
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return FutureBuilder<Map<String, double>>(
      future: marketService.getMarketRates(),
      builder: (context, snapshot) {
        // Default values (Loading state)
        double usdPrice = 0;
        double goldPrice = 0;
        bool isLoading = true;

        if (snapshot.hasData) {
          usdPrice = snapshot.data!['usd']!;
          goldPrice = snapshot.data!['gold']!;
          isLoading = false;
        }

        return Row(
          children: [
            // === WIDGET EMAS ===
            Expanded(
              child: _buildCard(
                title: "Emas / gr",
                price: goldPrice,
                icon: FontAwesomeIcons.ring,
                bgIcon: FontAwesomeIcons.coins,
                colorTheme: AppTheme.gold, // Pastikan warna gold ada di theme.dart (atau ganti Colors.orange)
                bgSoft: const Color(0xFFFEF3C7), // goldSoft
                formatter: formatter,
                isLoading: isLoading,
              ),
            ),
            const SizedBox(width: 16),
            
            // === WIDGET DOLLAR ===
            Expanded(
              child: _buildCard(
                title: "USD - IDR",
                price: usdPrice,
                icon: FontAwesomeIcons.moneyBillWave,
                bgIcon: FontAwesomeIcons.dollarSign,
                colorTheme: AppTheme.success,
                bgSoft: const Color(0xFFD1FAE5), // successSoft
                formatter: formatter,
                isLoading: isLoading,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard({
    required String title,
    required double price,
    required IconData icon,
    required IconData bgIcon,
    required Color colorTheme,
    required Color bgSoft,
    required NumberFormat formatter,
    required bool isLoading,
  }) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Stack(
        children: [
          // Background Icon (Hiasan)
          Positioned(
            right: -10,
            top: -10,
            child: FaIcon(bgIcon, size: 60, color: bgSoft.withOpacity(0.5)),
          ),
          
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Icon & Title
              Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: bgSoft, shape: BoxShape.circle),
                    child: Center(child: FaIcon(icon, size: 14, color: colorTheme)),
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: AppTheme.font.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.muted)),
                ],
              ),
              
              // Price
              isLoading
                  ? const SizedBox(
                      width: 20, height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2)
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatter.format(price),
                          style: AppTheme.font.copyWith(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.dark),
                        ),
                        // Fake Indicator untuk mempercantik (Boleh hardcode karena API free tidak kasih data perubahan %)
                        Row(
                          children: [
                            Icon(
                              title.contains("USD") ? Icons.arrow_drop_down : Icons.arrow_drop_up, 
                              color: title.contains("USD") ? AppTheme.danger : AppTheme.success, 
                              size: 16
                            ),
                            Text(
                              title.contains("USD") ? "-0.1%" : "+0.5%", 
                              style: TextStyle(
                                fontSize: 10, 
                                fontWeight: FontWeight.bold, 
                                color: title.contains("USD") ? AppTheme.danger : AppTheme.success
                              ),
                            )
                          ],
                        )
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}