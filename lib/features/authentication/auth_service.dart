import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception (Login): ${e.message}');
      return e.message ?? 'Terjadi kesalahan saat login.';
    }
  }

  Future<String?> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception (Register): ${e.message}');
      return e.message ?? 'Terjadi kesalahan saat mendaftar.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> updateUserName(String newName) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        return "Pengguna tidak ditemukan. Silakan login kembali.";
      }

      await user.updateDisplayName(newName);
      debugPrint('Berhasil memperbarui displayName di Firebase Auth.');

      await _firestore.collection('users').doc(user.uid).update({
        'name': newName,
      });
      debugPrint('Berhasil memperbarui nama di Firestore.');

      await user.reload();
      debugPrint('Data pengguna telah di-reload.');

      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException saat update nama: ${e.message}');
      return e.message ?? 'Terjadi kesalahan pada server autentikasi.';
    } on FirebaseException catch (e) {
      debugPrint(
        'FirebaseException saat update nama di Firestore: ${e.message}',
      );
      return e.message ?? 'Terjadi kesalahan pada database.';
    } catch (e) {
      debugPrint('Error tidak terduga saat update nama: $e');
      return 'Terjadi kesalahan tidak terduga. Silakan coba lagi.';
    }
  }
}
