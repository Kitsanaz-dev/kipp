// features/auth/presentation/screens/login_screen.dart
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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .login(_emailCtrl.text.trim(), _passCtrl.text);
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
                const SizedBox(height: 24),
                Text(
                  context.text.signIn,
                  style: context.typo.h2.copyWith(color: colors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  context.text.signInSubtitle,
                  style: context.typo.body.copyWith(color: colors.subtext),
                ),
                const SizedBox(height: 32),

                AppTextField(
                  label: context.text.email,
                  controller: _emailCtrl,
                  hint: 'demo@email.com',
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return context.text.pleaseEnterEmail;
                    }
                    if (!v.contains('@')) return context.text.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                AppTextField(
                  label: context.text.password,
                  controller: _passCtrl,
                  hint: context.text.enterYourPassword,
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
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
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
                                    strokeWidth: 2,
                                    color: colors.onPrimary,
                                  )
                                : CupertinoActivityIndicator(
                                    color: colors.onPrimary,
                                  ),
                          )
                        : Text(
                            context.text.login,
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
                        TextSpan(text: context.text.dontHaveAccount),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: () => context.push(RoutePaths.register),
                            child: Text(
                              context.text.signUp,
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
