import 'package:kipp/core/network/token_storage.dart';

class FakeTokenStorage extends TokenStorage {
  String? token;
  FakeTokenStorage([this.token]);

  @override
  Future<String?> getToken() async => token;

  @override
  Future<void> saveToken(String token) async => this.token = token;

  @override
  Future<void> clearToken() async => token = null;
}
