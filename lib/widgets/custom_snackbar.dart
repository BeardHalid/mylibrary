import 'package:flutter/material.dart';

class CustomSnackbar {
  CustomSnackbar._();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
    BuildContext context,
    Widget content,
    Color? color,
  ) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return null;

    return messenger.showSnackBar(
      SnackBar(
        content: content,
        backgroundColor: color ?? Colors.black,
        elevation: 10.0,
        margin: const EdgeInsets.all(20.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10.0)),
      ),
    );
  }
}
