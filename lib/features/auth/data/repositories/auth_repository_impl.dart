// features/auth/data/repositories/auth_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/token_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl(this.remote, this.tokenStorage);

  // TODO: replace local-only avatar storage with backend-synced avatar upload
  // once the API has an image upload endpoint.
  static String _avatarKey(String userId) => 'avatar_path_$userId';

  Future<String?> _readAvatarPath(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarKey(userId));
  }

  Future<void> _writeAvatarPath(String userId, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey(userId), path);
  }

  Never _rethrowDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw const NetworkException();
    }
    final data = e.response?.data;
    final message = data is Map && data['error'] is String
        ? data['error'] as String
        : (data is Map && data['message'] is String
            ? data['message'] as String
            : 'Something went wrong, please try again');
    throw ApiException(message);
  }

  @override
  Future<UserEntity> register(
      String name, String email, String password) async {
    try {
      final json = await remote.register(name.trim(), email.trim(), password);
      await tokenStorage.saveToken(json['token'] as String);
      return UserEntity.fromJson(json['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw const EmailAlreadyRegisteredException();
      }
      _rethrowDio(e);
    }
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final json = await remote.login(email.trim(), password);
      await tokenStorage.saveToken(json['token'] as String);
      return UserEntity.fromJson(json['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const InvalidCredentialsException();
      }
      _rethrowDio(e);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await tokenStorage.getToken();
    if (token == null || token.isEmpty) return null;

    try {
      final json = await remote.getMe();
      final user = UserEntity.fromJson(json);
      // avatar ເປັນ local-only: ອ່ານ path ຈາກ SharedPreferences ຕາມ user id.
      final avatarPath = await _readAvatarPath(user.id);
      return user.copyWith(avatarPath: avatarPath);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // token ໃຊ້ບໍ່ໄດ້ແລ້ວ (api_client ໄດ້ລ້າງໃຫ້ແລ້ວ ແຕ່ລ້າງຊ້ຳໃຫ້ແນ່ໃຈ).
        await tokenStorage.clearToken();
        return null;
      }
      _rethrowDio(e);
    }
  }

  @override
  Future<UserEntity> updateProfile(
    String userId, {
    String? name,
    String? avatarPath,
  }) async {
    try {
      final trimmed = name?.trim();
      final json = await remote.updateProfile(
        name: trimmed != null && trimmed.isNotEmpty ? trimmed : null,
      );
      var user = UserEntity.fromJson(json);

      // avatar: backend ຍັງບໍ່ຮອງຮັບ upload -> ເກັບ path ໄວ້ local ຕໍ່ device.
      if (avatarPath != null) {
        await _writeAvatarPath(user.id, avatarPath);
        user = user.copyWith(avatarPath: avatarPath);
      } else {
        user = user.copyWith(avatarPath: await _readAvatarPath(user.id));
      }
      return user;
    } on DioException catch (e) {
      _rethrowDio(e);
    }
  }

  @override
  Future<void> logout() => tokenStorage.clearToken();
}
