// features/expense/presentation/screens/profile_page.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/theme/app_theme.dart';
import 'package:kipp/features/expense/presentation/models/user_ui_model.dart';
import 'package:kipp/features/expense/presentation/widgets/theme_mode_sector.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- Avatar + ຂໍ້ມູນ user ----
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: colors.primary.withValues(alpha: 0.15),
                  child: Icon(Icons.person, size: 32, color: colors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mockUser.name,
                        style: context.typo.title.copyWith(color: colors.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mockUser.email,
                        style: context.typo.bodySmall.copyWith(color: colors.subtext),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(color: colors.inactiveContainer),
            const SizedBox(height: 8),

            // ---- Edit Profile Info ----
            _ProfileMenuTile(
              icon: Icons.edit_outlined,
              label: 'Edit Profile Info',
              onTap: () {
                // TODO: ໄປໜ້າ EditProfilePage ຕອນສ້າງໜ້ານັ້ນ
              },
            ),
            Divider(color: colors.inactiveContainer),

            // ---- Theme (ຝັງ selector ຢູ່ນຳ ບໍ່ຕ້ອງໄປໜ້າແຍກ) ----
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette_outlined, size: 20, color: colors.text),
                      const SizedBox(width: 12),
                      Text(
                        'Theme',
                        style: context.typo.subtitle.copyWith(color: colors.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const ThemeModeSelector(),
                ],
              ),
            ),
            Divider(color: colors.inactiveContainer),

            const SizedBox(height: 40),

            // ---- Log out ----
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => _confirmLogout(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.danger, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
                ),
                child: Text(
                  'Log out',
                  style: context.typo.subtitle.copyWith(
                    color: colors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final colors = context.colors;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        title: const Text('Log out'),
        content: const Text('ທ່ານແນ່ໃຈບໍ່ວ່າຢາກອອກຈາກລະບົບ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: colors.subtext)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // TODO: ref.read(authProvider.notifier).logout();
              // TODO: context.go(RoutePaths.start); ຫຼັງ logout ສຳເລັດ
            },
            child: Text('Log out', style: TextStyle(color: colors.danger, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.text),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: context.typo.subtitle.copyWith(color: colors.text)),
            ),
            Icon(Icons.chevron_right, size: 20, color: colors.subtext),
          ],
        ),
      ),
    );
  }
}