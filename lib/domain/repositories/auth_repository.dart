abstract class AuthRepository {
  bool get isLoggedIn;
  Future<void> login(String email, String password);
  Future<void> logout();
}
