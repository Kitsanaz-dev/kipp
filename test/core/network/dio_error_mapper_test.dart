import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/core/network/api_exceptions.dart';
import 'package:kipp/core/network/dio_error_mapper.dart';

DioException _err(DioExceptionType type, {Object? data}) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: type,
    response: data == null
        ? null
        : Response(requestOptions: options, statusCode: 400, data: data),
  );
}

void main() {
  for (final type in [
    DioExceptionType.connectionError,
    DioExceptionType.connectionTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.sendTimeout,
  ]) {
    test('$type → NetworkException (both modes)', () {
      expect(() => rethrowDio(_err(type)), throwsA(isA<NetworkException>()));
      expect(
        () => rethrowDio(_err(type), useServerMessage: true),
        throwsA(isA<NetworkException>()),
      );
    });
  }

  test('default mode ignores the server message', () {
    expect(
      () => rethrowDio(
        _err(DioExceptionType.badResponse, data: {'error': 'nope'}),
      ),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Something went wrong, please try again',
        ),
      ),
    );
  });

  group('useServerMessage', () {
    ApiException thrown(Object? data) {
      try {
        rethrowDio(
          _err(DioExceptionType.badResponse, data: data),
          useServerMessage: true,
        );
      } on ApiException catch (e) {
        return e;
      }
    }

    test('prefers `error`', () {
      expect(thrown({'error': 'E', 'message': 'M'}).message, 'E');
    });

    test('falls back to `message`', () {
      expect(thrown({'message': 'M'}).message, 'M');
    });

    test('generic text for non-map or missing fields', () {
      const generic = 'Something went wrong, please try again';
      expect(thrown('oops').message, generic);
      expect(thrown({'error': 42}).message, generic);
    });
  });
}
