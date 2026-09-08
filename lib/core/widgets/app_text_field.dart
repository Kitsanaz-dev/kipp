// core/widgets/app_text_field.dart
// Shared labelled text field used by the auth screens (login / register).
import 'package:flutter/material.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: context.typo.subtitle.copyWith(color: colors.text),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: context.typo.body.copyWith(color: colors.text),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.typo.body.copyWith(color: colors.hint),
            prefixIcon: Icon(icon, color: colors.subtext, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: colors.hintContainer,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: AppRadius.lgAll,
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.lgAll,
              borderSide: BorderSide(color: colors.danger),
            ),
          ),
        ),
      ],
    );
  }
}
