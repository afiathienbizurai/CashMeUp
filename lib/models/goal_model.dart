import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String title;
  final int targetAmount;
  final int currentAmount;
  final int colorIdx;
  final bool isCompleted; 

  GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.colorIdx,
    this.isCompleted = false, 
  });

  factory GoalModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return GoalModel(
      id: doc.id,
      title: data['title'] ?? '',
      targetAmount: data['target'] ?? 0,
      currentAmount: data['current'] ?? 0,
      colorIdx: data['colorIdx'] ?? 0,
      isCompleted: data['isCompleted'] ?? false, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'target': targetAmount,
      'current': currentAmount,
      'colorIdx': colorIdx,
      'isCompleted': isCompleted, 
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
  
  double get progress {
    if (targetAmount == 0) return 0.0;
    return (currentAmount / targetAmount).clamp(0.0, 1.0);
  }
  
  int get percent => (progress * 100).toInt();
}