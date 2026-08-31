// features/auth/presentation/screens/register_screen.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/router/route_paths.dart';

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
      // TODO: ref.read(authProvider.notifier).register(_nameCtrl.text, _emailCtrl.text, _passCtrl.text);
      await Future.delayed(const Duration(milliseconds: 400)); // placeholder
      if (!mounted) return;
      context.go(RoutePaths.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
                  'Sign up',
                  style: context.typo.h2.copyWith(color: colors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  'ສ້າງບັນຊີໃໝ່ເພື່ອເລີ່ມຄວບຄຸມການເງິນ',
                  style: context.typo.body.copyWith(color: colors.subtext),
                ),
                const SizedBox(height: 28),

                _buildLabel(context, 'Full Name'),
                _buildTextField(
                  context: context,
                  controller: _nameCtrl,
                  hint: 'ປ້ອນຊື່ຂອງເຈົ້າ',
                  icon: CupertinoIcons.person,
                  validator: (v) {
                    if (v == null || v.trim().length < 2)
                      return 'ຊື່ຕ້ອງມີຢ່າງໜ້ອຍ 2 ຕົວອັກສອນ';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                _buildLabel(context, 'Email'),
                _buildTextField(
                  context: context,
                  controller: _emailCtrl,
                  hint: 'demo@email.com',
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || !v.contains('@') || !v.contains('.'))
                      return 'ອີເມວບໍ່ຖືກຕ້ອງ';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                _buildLabel(context, 'Password'),
                _buildTextField(
                  context: context,
                  controller: _passCtrl,
                  hint: 'ຢ່າງໜ້ອຍ 6 ຕົວອັກສອນ',
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
                    if (v == null || v.length < 6)
                      return 'ລະຫັດຜ່ານຢ່າງໜ້ອຍ 6 ຕົວອັກສອນ';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                _buildLabel(context, 'Confirm Password'),
                _buildTextField(
                  context: context,
                  controller: _confirmCtrl,
                  hint: 'ປ້ອນລະຫັດຜ່ານອີກຄັ້ງ',
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
                  validator: (v) =>
                      v != _passCtrl.text ? 'ລະຫັດຜ່ານບໍ່ກົງກັນ' : null,
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
                            'Sign up',
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
                        const TextSpan(text: 'ມີບັນຊີແລ້ວ? '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(
                              'Login',
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

  Widget _buildLabel(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: context.typo.subtitle.copyWith(color: context.colors.text),
    ),
  );

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    final colors = context.colors;
    return TextFormField(
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
    );
  }
}
