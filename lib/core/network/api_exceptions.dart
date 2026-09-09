// core/network/api_exceptions.dart

/// ຖືກ throw ເມື່ອຕິດຕໍ່ backend ບໍ່ໄດ້ (ບໍ່ມີ internet / server ບໍ່ຕອບ / timeout).
class NetworkException implements Exception {
  final String message;
  const NetworkException([
    this.message =
        'Could not connect to the server. Please check your internet connection.',
  ]);

  @override
  String toString() => message;
}

/// ຂໍ້ຜິດພາດທົ່ວໄປຈາກ API ທີ່ບໍ່ໄດ້ map ເປັນ type ສະເພາະ.
class ApiException implements Exception {
  final String message;
  const ApiException([this.message = 'Something went wrong, please try again']);

  @override
  String toString() => message;
}
