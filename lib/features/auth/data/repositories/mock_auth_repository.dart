import 'dart:async';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final _authStateController = StreamController<bool>.broadcast();
  bool _isAuthenticated = false;

  MockAuthRepository() {
    // Initial state
    _authStateController.add(_isAuthenticated);
  }

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  @override
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network
    _isAuthenticated = true;
    _authStateController.add(true);
    return true;
  }

  @override
  Future<bool> loginWithApple() async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _authStateController.add(true);
    return true;
  }

  @override
  Future<bool> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _authStateController.add(true);
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isAuthenticated = false;
    _authStateController.add(false);
  }
}
