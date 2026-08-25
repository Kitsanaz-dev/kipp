class UserEntity {
  final String id;
  final String name;
  final String email;
  final String hashedPassword; // ພາຍຫຼັງຖ້າຕໍ່ API, server ຈະຈັດການແທນ

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.hashedPassword,
  });
}
