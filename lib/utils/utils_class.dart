
import 'package:flutter/material.dart';

class Utils {
  static showAlert(BuildContext context, String title, String messageText,
      String actionText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(messageText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(actionText),
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
        child: CircularProgressIndicator(),
      ),
    );
  }
}
