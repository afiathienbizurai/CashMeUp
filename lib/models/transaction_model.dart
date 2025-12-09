import 'package:cloud_firestore/cloud_firestore.dart';

// Skema database untuk transaksi
class TransactionModel {
  final String id;
  final String title;
  final int amount;
  final String type;
  final DateTime date;
  final String category;
  final int colorIdx; 

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
    this.colorIdx = 0, 
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    
    return TransactionModel(
      id: doc.id,
      title: data['note'] ?? data['category'] ?? 'Tanpa Judul',
      amount: data['amount'] ?? 0,
      type: data['type'] ?? 'expense',
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] ?? 'Umum',
      colorIdx: data['colorIdx'] ?? 0, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'category': category,
      'date': Timestamp.fromDate(date),
      'note': title,
      'colorIdx': colorIdx, // <--- SIMPAN KE FIREBASE
    };
  }
}