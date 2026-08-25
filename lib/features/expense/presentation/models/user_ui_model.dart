// features/auth/presentation/models/user_ui_model.dart
class UserUiModel {
  final String name;
  final String email;

  const UserUiModel({required this.name, required this.email});
}

// TODO: ລົບ mock ນີ້ອອກຕອນຕໍ່ ref.watch(currentUserProvider) ຈິງ
const mockUser = UserUiModel(name: 'Bob', email: 'bob@kipp.app');