class UserEntity {
  final String id;
  final String name;
  final String email;

  /// path ຮູບໃນ documents directory - local-only, device-local ເທົ່ານັ້ນ.
  /// ບໍ່ກ່ຽວກັບ backend `avatar_url` (ຍັງບໍ່ໄດ້ໃຊ້). null = ໃຊ້ placeholder.
  final String? avatarPath;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarPath,
  });

  /// map JSON shape ຈາກ backend (snake_case) ເປັນ entity.
  /// `avatar_url` ຈາກ backend ຍັງບໍ່ໄດ້ໃຊ້ - avatar ອ່ານຈາກ local storage ຕ່າງຫາກ.
  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['id'].toString(),
        name: (json['name'] ?? '') as String,
        email: (json['email'] ?? '') as String,
      );

  UserEntity copyWith({String? name, String? avatarPath}) => UserEntity(
        id: id,
        name: name ?? this.name,
        email: email,
        avatarPath: avatarPath ?? this.avatarPath,
      );
}
