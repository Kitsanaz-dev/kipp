// core/widgets/adaptive_spinner.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Platform-styled activity indicator: a Material [CircularProgressIndicator]
/// on Android, a [CupertinoActivityIndicator] elsewhere.
///
/// When [size] is given the indicator is wrapped in a square [SizedBox];
/// otherwise it takes its natural/parent size. [strokeWidth] only applies to
/// the Material indicator.
class AdaptiveSpinner extends StatelessWidget {
  const AdaptiveSpinner({
    super.key,
    this.size,
    this.color,
    this.strokeWidth = 2,
  });

  final double? size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final indicator = Platform.isAndroid
        ? CircularProgressIndicator(strokeWidth: strokeWidth, color: color)
        : CupertinoActivityIndicator(color: color);
    final size = this.size;
    if (size == null) return indicator;
    return SizedBox(width: size, height: size, child: indicator);
  }
}
