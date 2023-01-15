import 'package:flutter/material.dart';

class Util {
  static void showSnackBar(
    BuildContext context,
    String message, {
    String? actionText,
    bool error = false,
    Function()? onActionClick,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: actionText ?? 'Close',
          onPressed: onActionClick ?? () {},
        ),
      ),
    );
  }

  static void get hideKeyboard {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
