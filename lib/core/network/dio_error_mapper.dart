// core/network/dio_error_mapper.dart
import 'package:dio/dio.dart';

import 'api_exceptions.dart';

/// Maps a [DioException] to the app's exception types and throws it.
///
/// - Connection problems and timeouts → [NetworkException].
/// - Anything else → [ApiException]. When [useServerMessage] is true, the
///   backend's `error` (or else `message`) string field is used as the
///   message; otherwise the generic default message is used.
Never rethrowDio(DioException e, {bool useServerMessage = false}) {
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    throw const NetworkException();
  }
  if (!useServerMessage) throw const ApiException();

  final data = e.response?.data;
  final message = data is Map && data['error'] is String
      ? data['error'] as String
      : (data is Map && data['message'] is String
          ? data['message'] as String
          : 'Something went wrong, please try again');
  throw ApiException(message);
}
