import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:kipp/core/network/api_client.dart';
import 'package:kipp/core/network/api_exceptions.dart';
import 'package:kipp/features/expense/data/services/receipt_scanner_service.dart';

import '../../helpers/fake_token_storage.dart';

void main() {
  late Directory directory;
  late File receipt;
  late ApiClient client;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('receipt_test');
    receipt = await File(
      '${directory.path}/receipt.png',
    ).writeAsBytes(img.encodePng(img.Image(width: 1800, height: 900)));
    client = ApiClient(FakeTokenStorage('jwt'), dio: Dio());
  });

  tearDown(() async {
    client.dio.close(force: true);
    await directory.delete(recursive: true);
  });

  test('authenticated multipart upload resizes and maps snake_case', () async {
    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          expect(options.path, '/api/receipts/scan');
          expect(options.headers['Authorization'], 'Bearer jwt');
          expect(options.receiveTimeout, const Duration(seconds: 35));
          final form = options.data as FormData;
          expect(Map.fromEntries(form.fields), {
            'expense_types': 'Food,Other',
            'income_types': 'Salary',
          });
          expect(form.files.single.key, 'image');
          final file = form.files.single.value;
          expect(file.contentType.toString(), 'image/jpeg');
          final bytes = await file.finalize().expand((chunk) => chunk).toList();
          final uploaded = img.decodeJpg(Uint8List.fromList(bytes))!;
          expect(uploaded.width, 1600);
          expect(uploaded.height, 800);
          expect(bytes.length, lessThanOrEqualTo(2 * 1024 * 1024));
          handler.resolve(
            Response(
              requestOptions: options,
              data: {
                'amount': 42000,
                'is_income': true,
                'category': 'Salary',
                'description': 'Pay',
              },
            ),
          );
        },
      ),
    );
    final data = await ReceiptScannerService(
      client,
    ).scan(receipt, ['Food', 'Other'], ['Salary']);
    expect(data?.amount, 42000.0);
    expect(data?.isIncome, isTrue);
    expect(data?.category, 'Salary');
    expect(data?.description, 'Pay');
  });

  for (final code in ['scan_unavailable', 'scan_timeout', 'rate_limited']) {
    test('$code becomes ScanException', () async {
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 503,
                  data: {'code': code},
                ),
              ),
            );
          },
        ),
      );
      await expectLater(
        ReceiptScannerService(client).scan(receipt, [], []),
        throwsA(isA<ScanException>().having((e) => e.code, 'code', code)),
      );
    });
  }

  test('connection failure becomes NetworkException', () async {
    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
            ),
          );
        },
      ),
    );
    await expectLater(
      ReceiptScannerService(client).scan(receipt, [], []),
      throwsA(isA<NetworkException>()),
    );
  });
}
