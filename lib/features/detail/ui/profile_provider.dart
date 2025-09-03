import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/features/authentication/auth_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? get currentUser => _authRepository.currentUser;
  String? get userName => _authRepository.currentUser?.displayName;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileProvider({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<bool> updateUserName(String newName) async {
    if (newName == userName) return true;

    _setLoading(true);
    _clearError();

    final result = await _authRepository.updateUserName(newName);

    if (result == null) {
      _setLoading(false);

      notifyListeners();
      return true;
    } else {
      _setError(result);
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
  }

  void _clearError() {
    _errorMessage = null;
  }
}
