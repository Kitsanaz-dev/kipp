// core/widgets/user_avatar.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';

/// ຮູບ avatar ຂອງ user - ສະແດງຮູບຈາກ [path] ຖ້າ file ມີຢູ່, ບໍ່ດັ່ງນັ້ນ fallback ເປັນ placeholder icon.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.path, this.radius = 32});

  final String? path;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final file = path != null ? File(path!) : null;
    final hasImage = file != null && file.existsSync();

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primary.withValues(alpha: 0.15),
      backgroundImage: hasImage ? FileImage(file) : null,
      child: hasImage
          ? null
          : Icon(Icons.person, size: radius, color: colors.primary),
    );
  }
}
