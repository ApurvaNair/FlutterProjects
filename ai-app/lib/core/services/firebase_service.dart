import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Register new user
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("✅ User registered: ${_auth.currentUser?.email}");
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ signUp error: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected signUp error: $e");
      rethrow;
    }
  }

  /// Log in existing user
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      debugPrint("✅ Logged in as: ${_auth.currentUser?.email}");
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ login error: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("❌ Unexpected login error: $e");
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint("📧 Password reset email sent to $email");
    } catch (e) {
      debugPrint("❌ resetPassword error: $e");
      rethrow;
    }
  }

  /// Log out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint("👋 User signed out.");
    } catch (e) {
      debugPrint("❌ signOut error: $e");
      rethrow;
    }
  }

  /// Current authenticated user
  User? get currentUser => _auth.currentUser;
}
