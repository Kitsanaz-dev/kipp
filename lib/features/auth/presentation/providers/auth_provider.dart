// features/auth/presentation/providers/auth_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(AuthLocalDatasource());
}

/// Current signed-in user - single source of truth ສຳລັບ auth state.
/// build() ອ່ານ session ຈາກ Hive ຕອນເປີດແອັບ.
@riverpod
class Auth extends _$Auth {
  @override
  Future<UserEntity?> build() async {
    return ref.watch(authRepositoryProvider).getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    await ref.read(authRepositoryProvider).login(email, password);
    ref.invalidateSelf();
    await future; // ລໍໃຫ້ rebuild ສຳເລັດກ່ອນ return
  }

  Future<void> register(String name, String email, String password) async {
    await ref.read(authRepositoryProvider).register(name, email, password);
    ref.invalidateSelf();
    await future;
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    ref.invalidateSelf();
    await future;
  }
}
