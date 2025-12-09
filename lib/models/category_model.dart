import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String type; // 'income' atau 'expense'
  final int colorIdx;

  CategoryModel({required this.id, required this.name, required this.type, required this.colorIdx});

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? 'expense',
      colorIdx: data['colorIdx'] ?? 0,
    );
  }
}