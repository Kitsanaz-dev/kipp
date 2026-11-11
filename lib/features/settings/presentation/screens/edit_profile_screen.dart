// features/settings/presentation/screens/edit_profile_screen.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/adaptive_spinner.dart';
import 'package:kipp/core/widgets/app_snackbar.dart';
import 'package:kipp/core/widgets/glass_body.dart';
import 'package:kipp/core/widgets/user_avatar.dart';
import 'package:kipp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kipp/features/expense/presentation/widgets/kipp_app_bar.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _picker = ImagePicker();

  /// path ຮູບ avatar ທີ່ save ໄວ້ແລ້ວ (ຈາກ user record)
  String? _avatarPath;

  /// ຮູບໃໝ່ທີ່ຫາກໍເລືອກ - ຍັງຢູ່ໃນ cache ຂອງ picker, ຍັງບໍ່ copy ໄປບ່ອນຖາວອນ.
  /// copy ເຂົ້າ documents dir ໃນ _save() ເທົ່ານັ້ນ ເພື່ອບໍ່ໃຫ້ເກີດ file ຄ້າງ.
  String? _pendingImagePath;

  bool _initialised = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _showPhotoOptions() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              _pickImage(ImageSource.camera);
            },
            child: Text(context.text.takePhoto),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              _pickImage(ImageSource.gallery);
            },
            child: Text(context.text.chooseFromGallery),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(sheetContext),
          child: Text(context.text.cancel),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (picked == null || !mounted) return;

      // ຍັງບໍ່ copy ໄປບ່ອນຖາວອນ - ພຽງແຕ່ຈື່ path cache ໄວ້ສະແດງ preview
      setState(() => _pendingImagePath = picked.path);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, context.text.somethingWentWrong);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;

    setState(() => _isSaving = true);
    try {
      var newAvatarPath = _avatarPath;
      String? oldPathToDelete;

      final pending = _pendingImagePath;
      if (pending != null) {
        // copy ຮູບໃໝ່ເຂົ້າ documents dir ຕອນນີ້ເທົ່ານັ້ນ (ຫຼັງ user ຢືນຢັນ)
        final dir = await getApplicationDocumentsDirectory();
        final ext = pending.contains('.') ? pending.split('.').last : 'jpg';
        final filename = 'avatar_${DateTime.now().millisecondsSinceEpoch}.$ext';
        final saved = await File(pending).copy('${dir.path}/$filename');
        newAvatarPath = saved.path;

        if (_avatarPath != null && _avatarPath != newAvatarPath) {
          oldPathToDelete = _avatarPath;
        }
      }

      await ref
          .read(authProvider.notifier)
          .updateProfile(
            name: _nameCtrl.text.trim(),
            avatarPath: newAvatarPath,
          );

      // update ສຳເລັດແລ້ວ - ບໍ່ມີ record ອ້າງອີງຮູບເກົ່າ, ລົບໄດ້ຢ່າງປອດໄພ
      if (oldPathToDelete != null) {
        try {
          final oldFile = File(oldPathToDelete);
          if (await oldFile.exists()) await oldFile.delete();
        } catch (_) {
          // file ຄ້າງ 1 ໄຟລ໌ບໍ່ແມ່ນເລື່ອງໃຫຍ່ - ຢ່າໃຫ້ save ລົ້ມເຫລວ
        }
      }

      if (!mounted) return;
      AppSnackbar.showSuccess(context, context.text.profileUpdated);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, context.text.somethingWentWrong);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = ref.watch(authProvider).valueOrNull;

    // ໂຫຼດຄ່າເລີ່ມຕົ້ນຄັ້ງດຽວ ຫຼັງ user ພ້ອມ
    if (!_initialised && user != null) {
      _nameCtrl.text = user.name;
      _avatarPath = user.avatarPath;
      _initialised = true;
    }

    return GlassScaffold(
      backgroundColor: colors.background,
      extendBody: false,
      appBar: KippAppBar(
        title: context.text.editProfile,
        leading: const KippBackButton(),
      ),
      body: GlassBody(
        child: user == null
            ? const Center(child: CupertinoActivityIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _showPhotoOptions,
                            child: Column(
                              children: [
                                UserAvatar(
                                  path: _pendingImagePath ?? _avatarPath,
                                  radius: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  context.text.changePhoto,
                                  style: context.typo.bodySmall.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            context.text.fullName,
                            style: context.typo.subtitle.copyWith(
                              color: colors.text,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _nameCtrl,
                          style: context.typo.body.copyWith(color: colors.text),
                          decoration: InputDecoration(
                            hintText: context.text.enterYourName,
                            hintStyle: context.typo.body.copyWith(
                              color: colors.hint,
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.person,
                              color: colors.subtext,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: colors.hintContainer,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: AppRadius.lgAll,
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: AppRadius.lgAll,
                              borderSide: BorderSide(color: colors.danger),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().length < 2) {
                              return context.text.nameMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.xlAll,
                              ),
                            ),
                            child: _isSaving
                                ? AdaptiveSpinner(
                                    size: 22,
                                    color: colors.onPrimary,
                                  )
                                : Text(
                                    context.text.save,
                                    style: context.typo.title.copyWith(
                                      color: colors.onPrimary,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
