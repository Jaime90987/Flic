import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:proyecto_flic/values/colors.dart';

class InputEmail extends StatelessWidget {
  final TextEditingController emailController;
  final String? text;
  const InputEmail({
    super.key,
    required this.emailController,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    emailController.text = text ?? emailController.text;

    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Correo Electrónico",
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
        prefixIcon: Icon(Icons.email),
        prefixIconColor: AppColors.primary,
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return "Campo requerido";
        }
        if (!EmailValidator.validate(value.trim())) {
          return "Por favor introduce un correo válido";
        }
        return null;
      },
    );
  }
}
