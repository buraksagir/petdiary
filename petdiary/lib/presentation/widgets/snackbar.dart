import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class MySnackBar {
  SnackBar getSnackBar(dynamic text) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: AppTheme.lightTheme.colorScheme.primary, width: 5),
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      content: Text(text),
      dismissDirection: DismissDirection.endToStart,
      elevation: 15,
      duration: const Duration(seconds: 2),
    );
  }
}
