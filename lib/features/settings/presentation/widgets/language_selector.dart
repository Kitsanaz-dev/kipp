// features/settings/presentation/widgets/language_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/locale/locale_service.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeServiceProvider);

    return Row(
      children: [
        _LangChip(
          label: 'ລາວ',
          selected: current.languageCode == 'lo',
          onTap: () => ref.read(localeServiceProvider.notifier).setLocale(const Locale('lo')),
        ),
        const SizedBox(width: 8),
        _LangChip(
          label: 'English',
          selected: current.languageCode == 'en',
          onTap: () => ref.read(localeServiceProvider.notifier).setLocale(const Locale('en')),
        ),
      ],
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.hintContainer,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: selected ? colors.primary : colors.inactiveContainer,
          ),
        ),
        child: Text(
          label,
          style: context.typo.bodySmall.copyWith(
            color: selected ? colors.onPrimary : colors.text,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}