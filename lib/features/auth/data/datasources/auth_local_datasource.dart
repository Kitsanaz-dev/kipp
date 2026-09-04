// features/auth/data/datasources/auth_local_datasource.dart
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class AuthLocalDatasource {
  static const _usersBoxName = 'users_box';
  static const _sessionBoxName = 'session_box';
  static const _currentUserIdKey = 'currentUserId';

  Future<Box<UserModel>> _openUsersBox() =>
      Hive.openBox<UserModel>(_usersBoxName);

  Future<Box> _openSessionBox() => Hive.openBox(_sessionBoxName);

  Future<UserModel?> findByEmail(String email) async {
    final box = await _openUsersBox();
    final normalized = email.trim().toLowerCase();
    for (final user in box.values) {
      if (user.email.toLowerCase() == normalized) return user;
    }
    return null;
  }

  Future<UserModel?> getById(String id) async {
    final box = await _openUsersBox();
    return box.get(id);
  }

  Future<void> saveUser(UserModel model) async {
    final box = await _openUsersBox();
    await box.put(model.id, model);
  }

  Future<void> saveSession(String userId) async {
    final box = await _openSessionBox();
    await box.put(_currentUserIdKey, userId);
  }

  Future<String?> getSessionUserId() async {
    final box = await _openSessionBox();
    return box.get(_currentUserIdKey) as String?;
  }

  Future<void> clearSession() async {
    final box = await _openSessionBox();
    await box.delete(_currentUserIdKey);
  }
}
