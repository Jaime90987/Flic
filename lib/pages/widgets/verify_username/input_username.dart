import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proyecto_flic/services/firestore.dart';
import 'package:proyecto_flic/values/colors.dart';
import 'package:proyecto_flic/values/strings.dart';

class InputUsername extends StatelessWidget {
  final TextEditingController emailController;
  final String? text;
  const InputUsername({
    super.key,
    required this.emailController,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    emailController.text = text ?? emailController.text;
    bool isAvailable = false;
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Nombre de Usuario",
        labelStyle: TextStyle(color: AppColors.primary),
        filled: true,
        fillColor: Colors.white,
        helperText: "",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        prefixIcon: Icon(Icons.person),
        prefixIconColor: AppColors.primary,
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.requiredFieldText;
        }
        checkUsernameAvailability(value)
            .then((boleano) => isAvailable = boleano);
        if (!isAvailable) {
          log("2 $isAvailable");
          return "Nombre de usuario no disponible";
        }

        return null;
      },
    );
  }
}
