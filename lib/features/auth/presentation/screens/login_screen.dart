// features/auth/presentation/screens/login_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/router/route_paths.dart';

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
      // TODO: ref.read(authProvider.notifier).login(_emailCtrl.text, _passCtrl.text);
      await Future.delayed(const Duration(milliseconds: 400)); // placeholder
      if (!mounted) return;
      context.go(RoutePaths.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
                Text('Sign in', style: context.typo.h2.copyWith(color: colors.text)),
                const SizedBox(height: 4),
                Text('ຍິນດີຕ້ອນຮັບກັບມາ', style: context.typo.body.copyWith(color: colors.subtext)),
                const SizedBox(height: 32),

                _buildLabel(context, 'Email'),
                _buildTextField(
                  context: context,
                  controller: _emailCtrl,
                  hint: 'demo@email.com',
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'ກະລຸນາປ້ອນອີເມວ';
                    if (!v.contains('@')) return 'ອີເມວບໍ່ຖືກຕ້ອງ';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildLabel(context, 'Password'),
                _buildTextField(
                  context: context,
                  controller: _passCtrl,
                  hint: 'ປ້ອນລະຫັດຜ່ານ',
                  icon: CupertinoIcons.lock,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      color: colors.subtext,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6) return 'ລະຫັດຜ່ານຢ່າງໜ້ອຍ 6 ຕົວອັກສອນ';
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
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: colors.onPrimary),
                          )
                        : Text('Login', style: context.typo.title.copyWith(color: colors.onPrimary)),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: RichText(
                    text: TextSpan(
                      style: context.typo.bodySmall.copyWith(color: colors.subtext),
                      children: [
                        const TextSpan(text: "ຍັງບໍ່ມີບັນຊີ? "),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: () => context.push(RoutePaths.register),
                            child: Text(
                              'Sign up',
                              style: TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
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
        child: Text(text, style: context.typo.subtitle.copyWith(color: context.colors.text)),
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
        border: OutlineInputBorder(borderRadius: AppRadius.lgAll, borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(borderRadius: AppRadius.lgAll, borderSide: BorderSide(color: colors.danger)),
      ),
    );
  }
}