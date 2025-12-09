import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // READ
  Stream<List<CategoryModel>> getCategories() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(uid)
        .collection('categories')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc))
            .toList());
  }

  // CREATE
  Future<void> addCategory(CategoryModel category) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('users').doc(uid).collection('categories').add({
        'name': category.name,
        'type': category.type,
        'colorIdx': category.colorIdx,
      });
    }
  }

  // UPDATE
  Future<void> updateCategory(CategoryModel category) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('users').doc(uid).collection('categories').doc(category.id).update({
        'name': category.name,
        'type': category.type,
        'colorIdx': category.colorIdx,
      });
    }
  }

  // DELETE
  Future<void> deleteCategory(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('users').doc(uid).collection('categories').doc(id).delete();
    }
  }
}