import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _db
          .collection('users')
          .doc(_uid)
          .collection('transactions')
          .add(transaction.toMap());
    } catch (e) {
      throw Exception('Gagal menambah transaksi: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _db
          .collection('users')
          .doc(_uid)
          .collection('transactions')
          .doc(id) 
          .delete();
    } catch (e) {
      throw Exception('Gagal menghapus transaksi: $e');
    }
  }

  Stream<List<TransactionModel>> getTransactions() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .orderBy('date', descending: true) 
        .snapshots() 
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList());
  }
}