// features/expense/data/datasources/expense_remote_datasource.dart
import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

/// ຄຸຍກັບ Kipp Go backend /api/expenses. ຮັບ-ສົ່ງ raw JSON map -
/// ການ map ເປັນ entity ເປັນໜ້າທີ່ຂອງ repository.
class ExpenseRemoteDatasource {
  final ApiClient _client;

  ExpenseRemoteDatasource(this._client);

  Dio get _dio => _client.dio;

  /// GET /api/expenses
  Future<List<Map<String, dynamic>>> getAll() async {
    final res = await _dio.get<List<dynamic>>('/api/expenses');
    return (res.data ?? const [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  /// POST /api/expenses
  Future<Map<String, dynamic>> add(Map<String, dynamic> body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/api/expenses',
      data: body,
    );
    return res.data!;
  }

  /// PATCH /api/expenses/{id}
  Future<void> update(String id, Map<String, dynamic> body) async {
    await _dio.patch<dynamic>('/api/expenses/$id', data: body);
  }

  /// DELETE /api/expenses/{id}
  Future<void> delete(String id) async {
    await _dio.delete<dynamic>('/api/expenses/$id');
  }
}
