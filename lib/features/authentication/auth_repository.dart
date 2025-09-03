import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/features/authentication/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({required AuthService authService})
    : _authService = authService;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String?> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) {
    return _authService.createUserWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<void> signOut() => _authService.signOut();

  Future<String?> updateUserName(String newName) =>
      _authService.updateUserName(newName);
}
