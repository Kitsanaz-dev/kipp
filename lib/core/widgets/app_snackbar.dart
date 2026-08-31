// core/widgets/app_snackbar.dart
// Shared success / error snackbar used across features.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';

class AppSnackbar {
  AppSnackbar._();

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: CupertinoIcons.check_mark_circled_solid,
      backgroundColor: context.colors.ok,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: CupertinoIcons.xmark_circle_fill,
      backgroundColor: context.colors.danger,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        content: Row(
          children: [
            Icon(icon, color: context.colors.onPrimary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              // ✅ ກັນ overflow ຖ້າຂໍ້ຄວາມຍາວ (ເຊັ່ນ error.toString())
              child: Text(
                message,
                style: context.typo.body.copyWith(
                  color: context.colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
