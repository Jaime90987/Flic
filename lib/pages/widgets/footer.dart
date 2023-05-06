import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_flic/values/colors.dart';

class Footer extends StatelessWidget {
  final String message;
  final String message2;
  final VoidCallback function;
  const Footer({
    super.key,
    required this.message,
    required this.message2,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: message,
            style: const TextStyle(
              color: Colors.grey,
            ),
            children: [
              const WidgetSpan(child: SizedBox(width: 10)),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    function();
                  },
                text: message2,
                style: const TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
