import '../../core/error/app_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_storage_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageDataSource local;

  AuthRepositoryImpl(this.local);

  @override
  bool get isLoggedIn => local.isLoggedIn;

  @override
  Future<void> login(String email, String password) async {
    if (email.trim().toLowerCase() != 'demo@newsapp.com' ||
        password != 'password123') {
      throw const AppException(
        'Invalid credentials. Use the demo credentials shown below.',
      );
    }
    await local.setLoggedIn(true);
  }

  @override
  Future<void> logout() => local.setLoggedIn(false);
}
