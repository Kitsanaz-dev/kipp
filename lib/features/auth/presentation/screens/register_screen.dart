// features/auth/presentation/screens/register_screen.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:kipp/core/utils/auth_error_mapper.dart';
import 'package:kipp/core/widgets/app_snackbar.dart';
import 'package:kipp/core/widgets/app_text_field.dart';
import 'package:kipp/features/auth/presentation/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).register(
            _nameCtrl.text.trim(),
            _emailCtrl.text.trim(),
            _passCtrl.text,
          );
      if (!mounted) return;
      context.go(RoutePaths.home);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, mapAuthError(context, e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.pop(),
                  icon: Icon(CupertinoIcons.back, size: 22, color: colors.text),
                ),
                const SizedBox(height: 8),
                Text(
                  context.text.signUp,
                  style: context.typo.h2.copyWith(color: colors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  context.text.signUpSubtitle,
                  style: context.typo.body.copyWith(color: colors.subtext),
                ),
                const SizedBox(height: 28),

                AppTextField(
                  label: context.text.fullName,
                  controller: _nameCtrl,
                  hint: context.text.enterYourName,
                  icon: CupertinoIcons.person,
                  validator: (v) {
                    if (v == null || v.trim().length < 2) {
                      return context.text.nameMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                AppTextField(
                  label: context.text.email,
                  controller: _emailCtrl,
                  hint: 'demo@email.com',
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || !v.contains('@') || !v.contains('.')) {
                      return context.text.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                AppTextField(
                  label: context.text.password,
                  controller: _passCtrl,
                  hint: context.text.atLeastSixCharacters,
                  icon: CupertinoIcons.lock,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      color: colors.subtext,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return context.text.passwordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                AppTextField(
                  label: context.text.confirmPassword,
                  controller: _confirmCtrl,
                  hint: context.text.reenterYourPassword,
                  icon: CupertinoIcons.lock,
                  obscureText: _obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      color: colors.subtext,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) => v != _passCtrl.text
                      ? context.text.passwordsDoNotMatch
                      : null,
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.xlAll,
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: Platform.isAndroid
                                ? CircularProgressIndicator(
                                    color: colors.onPrimary,
                                  )
                                : CupertinoActivityIndicator(
                                    color: colors.onPrimary,
                                  ),
                          )
                        : Text(
                            context.text.signUp,
                            style: context.typo.title.copyWith(
                              color: colors.onPrimary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: RichText(
                    text: TextSpan(
                      style: context.typo.bodySmall.copyWith(
                        color: colors.subtext,
                      ),
                      children: [
                        TextSpan(text: context.text.alreadyHaveAccount),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(
                              context.text.login,
                              style: TextStyle(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
