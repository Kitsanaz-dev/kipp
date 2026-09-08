// features/auth/data/repositories/auth_repository_impl.dart
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/exceptions/auth_exceptions.dart';
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
      throw const EmailAlreadyRegisteredException();
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
      throw const InvalidCredentialsException();
    }

    await datasource.saveSession(user.id);
    return user.toEntity();
  }

  @override
  Future<UserEntity> updateProfile(
    String userId, {
    String? name,
    String? avatarPath,
  }) async {
    final user = await datasource.getById(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    final updated = UserModel(
      id: user.id,
      name: name?.trim().isNotEmpty == true ? name!.trim() : user.name,
      email: user.email,
      hashedPassword: user.hashedPassword,
      avatarPath: avatarPath ?? user.avatarPath,
    );
    await datasource.saveUser(updated);
    return updated.toEntity();
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
