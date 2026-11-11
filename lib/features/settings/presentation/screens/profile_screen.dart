// features/settings/presentation/screens/profile_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:kipp/core/widgets/app_snackbar.dart';
import 'package:kipp/core/widgets/glass_cta_button.dart';
import 'package:kipp/core/widgets/user_avatar.dart';
import 'package:kipp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kipp/features/settings/presentation/widgets/theme_mode_selector.dart';
import 'package:kipp/features/settings/presentation/widgets/language_selector.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final user = ref.watch(authProvider).valueOrNull;

    // router guard ກັນບໍ່ໃຫ້ເຂົ້າໜ້ານີ້ຕອນ logged out ຢູ່ແລ້ວ - guard ໄວ້ອີກຊັ້ນ
    if (user == null) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- Avatar + ຂໍ້ມູນ user ----
            Row(
              children: [
                UserAvatar(path: user.avatarPath),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: context.typo.title.copyWith(color: colors.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: context.typo.bodySmall.copyWith(
                          color: colors.subtext,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ---- Settings: one inset-grouped section (solid: it sits in
            // scrolling content). Theme / language selectors are transient
            // glass, which is allowed inside a solid section. ----
            GlassGroupedSection(
              surfaceStyle: GlassSurfaceStyle.solid,
              margin: EdgeInsets.zero,
              children: [
                _ProfileMenuTile(
                  icon: Icons.edit_outlined,
                  label: context.text.editProfileInfo,
                  onTap: () => context.push(RoutePaths.editProfile),
                ),
                _SettingTile(
                  icon: Icons.palette_outlined,
                  label: context.text.theme,
                  child: const ThemeModeSelector(),
                ),
                _SettingTile(
                  icon: CupertinoIcons.globe,
                  label: context.text.language,
                  child: const LanguageSelector(),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ---- Log out (outside the section: standalone glass) ----
            GlassCtaButton(
              height: 52,
              tint: colors.danger.withValues(alpha: 0.15),
              onPressed: () => _confirmLogout(context, ref),
              child: Text(
                context.text.logOut,
                style: context.typo.subtitle.copyWith(
                  color: colors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    GlassDialog.show<void>(
      context: context,
      barrierDismissible: true,
      title: context.text.logOut,
      message: context.text.logOutConfirm,
      actions: [
        GlassDialogAction(
          label: context.text.cancel,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        GlassDialogAction(
          label: context.text.logOut,
          isDestructive: true,
          onPressed: () async {
            // Close the dialog (it lives on the root navigator), then log out.
            Navigator.of(context, rootNavigator: true).pop();
            try {
              await ref.read(authProvider.notifier).logout();
              if (!context.mounted) return;
              context.go(RoutePaths.start);
            } catch (_) {
              if (!context.mounted) return;
              AppSnackbar.showError(context, context.text.somethingWentWrong);
            }
          },
        ),
      ],
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
    return GlassListTile(
      leading: Icon(icon, size: 20, color: colors.text),
      title: Text(
        label,
        style: context.typo.subtitle.copyWith(color: colors.text),
      ),
      trailing: GlassListTile.chevron,
      onTap: onTap,
    );
  }
}

/// Row with an icon + label header and an inline control below it.
class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GlassListTile(
      leading: Icon(icon, size: 20, color: colors.text),
      title: Text(
        label,
        style: context.typo.subtitle.copyWith(color: colors.text),
      ),
      subtitle: Padding(padding: const EdgeInsets.only(top: 12), child: child),
    );
  }
}
