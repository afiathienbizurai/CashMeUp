import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';

class TransactionProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  // Getter Stream
  Stream<List<TransactionModel>> get transactionStream => _service.getTransactions();

  // Add Data
  Future<void> addTransaction(TransactionModel tx) async {
    try {
      await _service.addTransaction(tx);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // --- TAMBAHKAN FUNGSI INI (DELETE) ---
  Future<void> deleteTransaction(String id) async {
    try {
      // Kita panggil service delete (yang akan kita update sebentar lagi)
      // Atau bisa langsung panggil Firestore di sini jika code sebelumnya digabung
      await _service.deleteTransaction(id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}