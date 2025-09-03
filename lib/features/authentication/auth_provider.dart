import 'package:flutter/foundation.dart';
import 'package:restaurant_app/features/authentication/auth_repository.dart';

enum AuthViewState { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository;

  AuthViewState _state = AuthViewState.idle;
  AuthViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setState(AuthViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  Future<bool> _handleAuthAction(Future<String?> Function() authAction) async {
    _setState(AuthViewState.loading);
    _clearError();

    final error = await authAction();

    if (error == null) {
      _setState(AuthViewState.success);
      return true;
    } else {
      _errorMessage = error;
      _setState(AuthViewState.error);
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    return _handleAuthAction(
      () => _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<bool> signUp(String name, String email, String password) async {
    return _handleAuthAction(
      () => _authRepository.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
