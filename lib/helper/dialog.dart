import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String msg, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      elevation: 0,
      backgroundColor: color,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(milliseconds: 600),
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}
