import 'package:flutter/material.dart';
import 'package:proyecto_flic/values/colors.dart';

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback function;
  const SendButton({
    super.key,
    required this.text,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => function(),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(310, 48),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.blueGrey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}
