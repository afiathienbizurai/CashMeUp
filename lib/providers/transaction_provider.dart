import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';

class TransactionProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  
  Stream<List<TransactionModel>> get transactionStream => _service.getTransactions();

  Future<void> addTransaction(TransactionModel tx) async {
    try {
      await _service.addTransaction(tx);
      notifyListeners(); 
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _service.deleteTransaction(id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}