// features/auth/domain/exceptions/auth_exceptions.dart

/// ຖືກ throw ຕອນ register ດ້ວຍ email ທີ່ມີບັນຊີຢູ່ແລ້ວ
class EmailAlreadyRegisteredException implements Exception {
  const EmailAlreadyRegisteredException();
}

/// ຖືກ throw ຕອນ login ດ້ວຍ email/password ທີ່ບໍ່ກົງ
class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}
