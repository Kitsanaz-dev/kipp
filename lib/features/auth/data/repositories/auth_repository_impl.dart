// features/auth/data/repositories/auth_repository_impl.dart
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  static const _uuid = Uuid();

  String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  @override
  Future<UserEntity> register(
      String name, String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();

    final existing = await datasource.findByEmail(normalizedEmail);
    if (existing != null) {
      throw Exception('This email is already registered');
    }

    final model = UserModel(
      id: _uuid.v4(),
      name: name.trim(),
      email: normalizedEmail,
      hashedPassword: _hash(password),
    );
    await datasource.saveUser(model);
    await datasource.saveSession(model.id);
    return model.toEntity();
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();

    final user = await datasource.findByEmail(normalizedEmail);
    if (user == null || user.hashedPassword != _hash(password)) {
      throw Exception('Incorrect email or password');
    }

    await datasource.saveSession(user.id);
    return user.toEntity();
  }

  @override
  Future<void> logout() => datasource.clearSession();

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userId = await datasource.getSessionUserId();
    if (userId == null) return null;
    final user = await datasource.getById(userId);
    return user?.toEntity();
  }
}
