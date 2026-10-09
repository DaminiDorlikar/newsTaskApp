import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/repository_providers.dart';

final authProvider =
    AsyncNotifierProvider<AuthController, bool>(AuthController.new);

class AuthController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return ref.read(authRepositoryProvider).isLoggedIn;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(authRepositoryProvider).login(email, password);
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(authRepositoryProvider).logout();
        return false;
      },
    );
  }
}
