import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:kipp/core/network/api_client.dart';
import 'package:kipp/core/network/dio_error_mapper.dart';

class ScannedReceiptData {
  final double? amount;
  final String? category;
  final String? description;
  final bool? isIncome;

  const ScannedReceiptData({
    this.amount,
    this.category,
    this.description,
    this.isIncome,
  });
}

/// The presentation layer translates the stable backend code for the locale.
class ScanException implements Exception {
  final String code;
  const ScanException(this.code);
}

Uint8List _prepareImage(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) throw const ScanException('invalid_image');
  var image = img.bakeOrientation(decoded);
  final longEdge = math.max(image.width, image.height);
  if (longEdge > 1600) {
    final scale = 1600 / longEdge;
    image = img.copyResize(
      image,
      width: (image.width * scale).round(),
      height: (image.height * scale).round(),
    );
  }
  var jpeg = img.encodeJpg(image, quality: 85);
  while (jpeg.length > 2 * 1024 * 1024 && image.width > 1 && image.height > 1) {
    image = img.copyResize(
      image,
      width: math.max(1, (image.width * .8).round()),
      height: math.max(1, (image.height * .8).round()),
    );
    jpeg = img.encodeJpg(image, quality: 85);
  }
  return jpeg;
}

class ReceiptScannerService {
  final ApiClient _client;
  ReceiptScannerService(this._client);

  Future<ScannedReceiptData?> scan(
    File imageFile,
    List<String> expenseTypes,
    List<String> incomeTypes,
  ) async {
    final bytes = await compute(_prepareImage, await imageFile.readAsBytes());
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        '/api/receipts/scan',
        data: FormData.fromMap({
          'image': MultipartFile.fromBytes(
            bytes,
            filename: 'receipt.jpg',
            contentType: DioMediaType('image', 'jpeg'),
          ),
          'expense_types': expenseTypes.join(','),
          'income_types': incomeTypes.join(','),
        }),
        options: Options(receiveTimeout: const Duration(seconds: 35)),
      );
      final data = response.data;
      if (data == null) return null;
      return ScannedReceiptData(
        amount: (data['amount'] as num?)?.toDouble(),
        isIncome: data['is_income'] as bool?,
        category: data['category'] as String?,
        description: data['description'] as String?,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final code = data is Map ? data['code'] : null;
      if (const [
        'scan_unavailable',
        'scan_timeout',
        'rate_limited',
      ].contains(code)) {
        throw ScanException(code as String);
      }
      rethrowDio(e);
    }
  }
}
