import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String name, String email, String password);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser(); // ໃຊ້ check session ຕອນເປີດແອັບ

  /// ອັບເດດ name ແລະ/ຫຼື avatar ຂອງ user. field ທີ່ເປັນ null ຈະຄົງຄ່າເກົ່າໄວ້.
  Future<UserEntity> updateProfile(
    String userId, {
    String? name,
    String? avatarPath,
  });
}
