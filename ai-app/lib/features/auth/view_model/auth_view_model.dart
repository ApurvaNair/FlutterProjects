import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/firebase_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService;

  AuthViewModel(this._firebaseService);

  bool isLoading = false;
  String? error;

  void _handleError(Object e, StackTrace stack) {
    if (e is FirebaseAuthException) {
      error = e.message ?? "Authentication failed.";
    } else {
      error = "Unexpected error. Please try again.";
      debugPrint("🚨 Auth error: $e");
      debugPrint("📍 Stack trace:\n$stack");
    }
    notifyListeners();
  }

  /// Returns `true` if login succeeded, `false` otherwise
  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _firebaseService.login(email, password);

      return true;
    } catch (e, stack) {
      _handleError(e, stack);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Returns `true` if sign-up succeeded, `false` otherwise
  Future<bool> signUp(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _firebaseService.signUp(email, password);

      return true;
    } catch (e, stack) {
      _handleError(e, stack);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      error = null;
      await _firebaseService.resetPassword(email);
    } catch (e, stack) {
      _handleError(e, stack);
    }
  }
}
