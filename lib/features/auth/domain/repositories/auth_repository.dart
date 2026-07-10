abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> loginWithGoogle();
  Future<bool> loginWithApple();
  Future<void> logout();
  Stream<bool> get authStateChanges;
}
