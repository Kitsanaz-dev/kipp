// features/expense/presentation/screens/receipt_capture_screen.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/constant/radius.dart';

class ReceiptCaptureScreen extends StatefulWidget {
  const ReceiptCaptureScreen({super.key});

  @override
  State<ReceiptCaptureScreen> createState() => _ReceiptCaptureScreenState();
}

class _ReceiptCaptureScreenState extends State<ReceiptCaptureScreen> {
  CameraController? _controller;
  final _imagePicker = ImagePicker();
  bool _isPermissionGranted = false;
  bool _isCapturing = false;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInit();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _requestPermissionAndInit() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    if (!status.isGranted) {
      setState(() => _isPermissionGranted = false);
      return;
    }
    setState(() => _isPermissionGranted = true);
    await _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      if (!mounted) return;

      setState(() => _controller = controller);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);
    try {
      final xfile = await controller.takePicture();
      if (!mounted) return;
      context.pop(File(xfile.path));
    } catch (e) {
      debugPrint('Capture error: $e');
      setState(() => _isCapturing = false);
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isPicking) return;

    setState(() => _isPicking = true);

    try {
      final xfile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (xfile == null || !mounted) return;
      context.pop(File(xfile.path));
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    } finally {
      // ✅ ປົດລັອກປຸ່ມເມື່ອເຮັດວຽກສຳເລັດ ຫຼື ເກີດ error
      if (mounted) setState(() => _isPicking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.text,
      appBar: AppBar(
        backgroundColor: colors.text,
        iconTheme: IconThemeData(color: colors.onPrimary),
        title: Text(
          context.text.scanReceipt,
          style: TextStyle(color: colors.onPrimary),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: AppRadius.lgAll,
                child: _buildPreview(colors),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ✅ ປຸ່ມ gallery (ຊ້າຍ)
                  IconButton(
                    onPressed: _pickFromGallery,
                    icon: Icon(
                      CupertinoIcons.photo_fill,
                      color: colors.onPrimary,
                      size: 30,
                    ),
                  ),

                  // ປຸ່ມຖ່າຍ (ກາງ, ໃຫຍ່ສຸດ)
                  GestureDetector(
                    onTap: _capture,
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary,
                        border: Border.all(color: colors.onPrimary, width: 3),
                      ),
                      child: _isCapturing
                          ? Padding(
                              padding: const EdgeInsets.all(18),
                              child: Platform.isAndroid
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colors.onPrimary,
                                    )
                                  : const CupertinoActivityIndicator(),
                            )
                          : Icon(
                              CupertinoIcons.camera,
                              color: colors.onPrimary,
                              size: 28,
                            ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(dynamic colors) {
    if (!_isPermissionGranted) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Text(
            context.text.cameraPermissionRequired,
            style: TextStyle(color: colors.onPrimary),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator(strokeWidth: 2, color: colors.onPrimary)
            : CupertinoActivityIndicator(color: colors.onPrimary),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }
}
