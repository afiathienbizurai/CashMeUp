import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketService {
  // API USD Gratis (Update harian)
  final String _usdUrl = "https://api.exchangerate-api.com/v4/latest/USD";
  
  // API Emas Gratis (Sering dipakai untuk demo)
  // Mengambil harga emas dalam IDR per Ounce, nanti kita konversi ke Gram
  final String _goldUrl = "https://data-asg.goldprice.org/dbXRates/IDR";

  Future<Map<String, double>> getMarketRates() async {
    double usdRate = 16000; // Default fallback
    double goldRate = 1300000; // Default fallback

    try {
      // 1. Ambil Data USD
      final usdResponse = await http.get(Uri.parse(_usdUrl));
      if (usdResponse.statusCode == 200) {
        final data = json.decode(usdResponse.body);
        usdRate = (data['rates']['IDR'] as num).toDouble();
      }

      // 2. Ambil Data Emas
      final goldResponse = await http.get(Uri.parse(_goldUrl));
      if (goldResponse.statusCode == 200) {
        final data = json.decode(goldResponse.body);
        // Data API: harga per Ounce. 1 Ounce = 31.1035 Gram
        // items[0].xPrice adalah harga per ounce dalam IDR
        final pricePerOunce = (data['items'][0]['xPrice'] as num).toDouble();
        goldRate = pricePerOunce / 31.1035; 
      }

      return {
        'usd': usdRate,
        'gold': goldRate,
      };
    } catch (e) {
      // Jika error (misal offline), kembalikan nilai default
      // Dalam clean code yang ketat, ini sebaiknya throw error, 
      // tapi untuk UI Tugas Akhir agar tidak crash, kita return default.
      return {
        'usd': usdRate,
        'gold': goldRate,
      };
    }
  }
}