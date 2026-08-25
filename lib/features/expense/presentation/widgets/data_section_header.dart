// features/expense/presentation/widgets/date_section_header.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/theme/app_theme.dart';

class DateSectionHeader extends StatelessWidget {
  const DateSectionHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: context.typo.subtitle.copyWith(
              color: context.colors.subtext,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(color: context.colors.inactiveContainer, thickness: 1),
          ),
        ],
      ),
    );
  }
}