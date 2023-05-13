import 'package:flutter/material.dart';
import 'package:proyecto_flic/pages/main_page.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/services/firestore.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:proyecto_flic/values/colors.dart';

class VerifyUsernamePage extends StatefulWidget {
  const VerifyUsernamePage({super.key});

  @override
  State<VerifyUsernamePage> createState() => _VerifyUsernamePageState();
}

class _VerifyUsernamePageState extends State<VerifyUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  bool hasUsername = false;
  TextEditingController userNameController = TextEditingController();
  bool _usernameAvailable = true;

  void _validateUsername(String? value) async {
    if (value != null && value.isNotEmpty) {
      bool isAvailable = await checkUsernameAvailability(value);
      setState(() {
        _usernameAvailable = isAvailable;
      });
    }
  }

  @override
  Widget build(BuildContext context) => hasUsername
      ? const MainPage()
      : Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "¿Quien eres?",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "Por favor escribe un nombre de usuario para identificarte en Flic.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // InputUsername(emailController: userNameController),
                    TextFormField(
                      controller: userNameController,
                      keyboardType: TextInputType.name,
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
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 1.5),
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
                      onChanged: (value) {
                        _validateUsername(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre de usuario';
                        } else if (!_usernameAvailable) {
                          return 'Este nombre de usuario ya está en uso';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    SendButton(
                        text: "Aceptar",
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            saveUsername(
                              Auth.user.uid,
                              userNameController.text.trim(),
                            );
                            Navigator.pushReplacementNamed(context, "/main");
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
}
