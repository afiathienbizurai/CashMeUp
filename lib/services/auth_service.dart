import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'displayName': name,
          'createdAt': Timestamp.now(),
          'pushNotification': true,
        });
        
        _createDefaultCategories(user.uid);
      }
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        
        await _db.collection('users').doc(user.uid).update({
          'displayName': newName,
        });

        await user.reload();
      }
    } catch (e) {
      throw Exception('Gagal ganti nama: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _createDefaultCategories(String uid) async {
    final categories = [
      {'name': 'Makan', 'type': 'expense', 'colorIdx': 1},
      {'name': 'Transport', 'type': 'expense', 'colorIdx': 5},
      {'name': 'Gaji', 'type': 'income', 'colorIdx': 3},
      {'name': 'Belanja', 'type': 'expense', 'colorIdx': 6 },
    ];
    
    var batch = _db.batch();
    for (var cat in categories) {
      var docRef = _db.collection('users').doc(uid).collection('categories').doc();
      batch.set(docRef, cat);
    }
    await batch.commit();
  }
}