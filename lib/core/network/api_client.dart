// core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'token_storage.dart';

/// ຫໍ່ Dio instance ໜຶ່ງ ພ້ອມ baseUrl + interceptor ສຳລັບ JWT auth.
///
/// ສ້າງຜ່ານ DI (constructor injection) ບໍ່ແມ່ນ global singleton - ເບິ່ງ
/// `apiClientProvider` ໃນ network_providers.dart.
class ApiClient {
  final TokenStorage _tokenStorage;
  late final Dio dio;

  /// endpoint ທີ່ບໍ່ຕ້ອງແນບ Authorization header (ຍັງບໍ່ມີ token ຕອນນັ້ນ).
  static const _noAuthPaths = <String>{
    '/api/auth/register',
    '/api/auth/login',
  };

  ApiClient(this._tokenStorage, {Dio? dio}) {
    this.dio = dio ??
        Dio(BaseOptions(
          baseUrl: dotenv.env['API_BASE_URL'] ?? '',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ));

    this.dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final needsAuth = !_noAuthPaths.contains(options.path);
              if (needsAuth) {
                final token = await _tokenStorage.getToken();
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
              }
              handler.next(options);
            },
            onError: (e, handler) async {
              // 401 = token ໝົດອາຍຸ/ບໍ່ຖືກຕ້ອງ: ລ້າງ token ອອກເພື່ອໃຫ້ແອັບ
              // ຖືວ່າ logged out ແລ້ວ ແຕ່ຍັງ propagate error ໃຫ້ caller ຈັດການ.
              if (e.response?.statusCode == 401) {
                await _tokenStorage.clearToken();
              }
              handler.next(e);
            },
          ),
        );
  }
}
