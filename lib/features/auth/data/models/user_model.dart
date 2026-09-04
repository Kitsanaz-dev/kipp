// features/auth/data/models/user_model.dart
import 'package:hive_ce/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1) // typeId: 2 ໃຊ້ໂດຍ ExpenseModel ໄປແລ້ວ
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String hashedPassword; // ເກັບເປັນ sha256 hash ບໍ່ແມ່ນ plain text

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.hashedPassword,
  });

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        hashedPassword: hashedPassword,
      );

  factory UserModel.fromEntity(UserEntity e) => UserModel(
        id: e.id,
        name: e.name,
        email: e.email,
        hashedPassword: e.hashedPassword,
      );
}
