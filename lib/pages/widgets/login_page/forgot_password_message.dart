import 'package:flutter/material.dart';
import 'package:proyecto_flic/values/colors.dart';
import 'package:proyecto_flic/values/strings.dart';

class ForgotPasswordMessage extends StatelessWidget {
  const ForgotPasswordMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed("/forgot_password"),
          child: const Text(
            AppStrings.forgotPassword,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
