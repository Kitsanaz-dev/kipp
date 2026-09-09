// features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

/// ຄຸຍກັບ Kipp Go backend ໂດຍກົງ. return raw JSON map ຕາມທີ່ backend ສົ່ງມາ -
/// ການ parse ເປັນ entity ເປັນໜ້າທີ່ຂອງ repository.
class AuthRemoteDatasource {
  final ApiClient _client;

  AuthRemoteDatasource(this._client);

  Dio get _dio => _client.dio;

  /// POST /api/auth/register -> {token, user}
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/api/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
    return res.data!;
  }

  /// POST /api/auth/login -> {token, user}
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );
    return res.data!;
  }

  /// GET /api/auth/me -> user JSON
  Future<Map<String, dynamic>> getMe() async {
    final res = await _dio.get<Map<String, dynamic>>('/api/auth/me');
    return res.data!;
  }

  /// PATCH /api/users/me -> updated user JSON. ສົ່ງສະເພາະ field ທີ່ໃຫ້ມາ.
  /// ບໍ່ສົ່ງ avatar ໄປ backend (avatar ຍັງເປັນ local-only).
  Future<Map<String, dynamic>> updateProfile({String? name}) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;

    final res = await _dio.patch<Map<String, dynamic>>(
      '/api/users/me',
      data: body,
    );
    return res.data!;
  }
}
