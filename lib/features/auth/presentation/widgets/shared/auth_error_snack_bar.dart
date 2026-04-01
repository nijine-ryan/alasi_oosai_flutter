import 'package:flutter/material.dart';

/// Themed error snackbar for the auth flow.
/// Matches the dark-surface card aesthetic: slate background, rounded corners,
/// soft warning icon. Call [AuthErrorSnackBar.show] from any widget that has
/// a [BuildContext] inside a [Scaffold].
class AuthErrorSnackBar {
  AuthErrorSnackBar._();

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFFCA5A5),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFF8FAFC),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          duration: const Duration(seconds: 3),
          elevation: 8,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
  }
}
