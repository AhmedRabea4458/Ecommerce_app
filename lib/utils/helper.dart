import 'package:flutter/material.dart';

class AppSnackBar {

  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Colors.green.shade600,
      Icons.check_circle,
    );
  }


  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Colors.red.shade600,
      Icons.error,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Colors.orange.shade700,
      Icons.warning,
    );
  }


  static void _showSnackBar(
      BuildContext context,
      String message,
      Color backgroundColor,
      IconData icon,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void clearControllers(List<TextEditingController> controllers) {
  for (var controller in controllers) {
    controller.clear();
  }
}
