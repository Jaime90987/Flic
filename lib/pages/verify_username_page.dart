import 'package:flutter/material.dart';
import 'package:proyecto_flic/pages/main_page.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/pages/widgets/verify_username/input_username.dart';
import 'package:proyecto_flic/services/firestore.dart';
import 'package:proyecto_flic/services/mail_auth.dart';

class VerifyUsernamePage extends StatefulWidget {
  const VerifyUsernamePage({super.key});

  @override
  State<VerifyUsernamePage> createState() => _VerifyUsernamePageState();
}

class _VerifyUsernamePageState extends State<VerifyUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  bool hasUsername = false;
  TextEditingController userNameController = TextEditingController();

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
                    InputUsername(emailController: userNameController),
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
