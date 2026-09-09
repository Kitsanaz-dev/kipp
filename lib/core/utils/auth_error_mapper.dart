// core/utils/auth_error_mapper.dart
import 'package:flutter/widgets.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/network/api_exceptions.dart';
import 'package:kipp/features/auth/domain/exceptions/auth_exceptions.dart';

/// ແປງ exception ຈາກ auth layer ເປັນຂໍ້ຄວາມ localized ໃຫ້ຜູ້ໃຊ້ເຫັນ.
/// ໃຊ້ຮ່ວມກັນລະຫວ່າງ login ແລະ register screen.
String mapAuthError(BuildContext context, Object e) {
  if (e is EmailAlreadyRegisteredException) {
    return context.text.emailAlreadyRegistered;
  }
  if (e is InvalidCredentialsException) {
    return context.text.incorrectEmailOrPassword;
  }
  if (e is NetworkException) {
    return context.text.networkError;
  }
  if (e is ApiException) {
    return e.message;
  }
  return context.text.somethingWentWrong;
}
