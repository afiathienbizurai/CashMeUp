import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/goal_model.dart';

class GoalProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<GoalModel>> getGoals() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(uid)
        .collection('goals')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => GoalModel.fromFirestore(doc)).toList());
  }

  Future<void> addGoal(GoalModel goal) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('users').doc(uid).collection('goals').add(goal.toMap());
    }
  }

  Future<void> updateGoal(String id, int newCurrentAmount) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('users').doc(uid).collection('goals').doc(id).update({
        'current': newCurrentAmount,
      });
    }
  }
  
  Future<void> deleteGoal(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('users').doc(uid).collection('goals').doc(id).delete();
    }
  }
}