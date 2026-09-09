// core/network/token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ເກັບ JWT token ໄວ້ໃນ secure storage (Keychain/Keystore) - ບໍ່ເກັບໃນ Hive
/// ຫຼື SharedPreferences ເພາະມັນເປັນ credential.
class TokenStorage {
  final _storage = const FlutterSecureStorage();
  static const _key = 'auth_token';

  Future<void> saveToken(String token) => _storage.write(key: _key, value: token);
  Future<String?> getToken() => _storage.read(key: _key);
  Future<void> clearToken() => _storage.delete(key: _key);
}
