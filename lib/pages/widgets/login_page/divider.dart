import 'package:flutter/material.dart';
import 'package:proyecto_flic/values/colors.dart';
import 'package:proyecto_flic/values/strings.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(
          child: Divider(
            color: AppColors.primary,
            thickness: .9,
          ),
        ),
        SizedBox(width: 3),
        Text(
          AppStrings.orLoginWith,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        SizedBox(width: 3),
        Expanded(
          child: Divider(
            color: AppColors.primary,
            thickness: .9,
          ),
        ),
      ],
    );
  }
}
