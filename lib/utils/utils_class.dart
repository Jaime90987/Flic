import 'package:flutter/material.dart';
import 'package:proyecto_flic/values/colors.dart';

class Utils {
  static showAlert(
    BuildContext context,
    GlobalKey<NavigatorState> navigatorKey,
    String title,
    String messageText,
    String actionText,
    bool isForgotPassoword,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(messageText),
        actions: [
          TextButton(
            onPressed: () => !isForgotPassoword
                ? Navigator.pop(context)
                : navigatorKey.currentState!.popUntil((route) => route.isFirst),
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static showConfirmAlert(
    BuildContext context,
    GlobalKey<NavigatorState> navigatorKey,
    String title,
    String messageText,
    String actionText1,
    String actionText2,
    VoidCallback function,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(messageText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              actionText1,
              style: const TextStyle(fontSize: 18, color: Color(0xFF14171A)),
            ),
          ),
          TextButton(
            onPressed: function,
            child: Text(
              actionText2,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static showLoadingCircle(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
