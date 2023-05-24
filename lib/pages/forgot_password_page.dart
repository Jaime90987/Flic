import 'package:flutter/material.dart';
import 'package:proyecto_flic/main.dart';
import 'package:proyecto_flic/pages/widgets/common/input_email.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/pages/widgets/forgot_password_page/clip_path_forgot_password.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:proyecto_flic/utils/utils_class.dart';

class ForgotPasswordPage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const ForgotPasswordPage({super.key, required this.navigatorKey});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              const MyClipPathForgotPassword(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Image.asset("assets/images/loginImage.png", height: 120),
                      const SizedBox(height: 25),
                      InputEmail(emailController: emailController),
                      const SizedBox(height: 70),
                      SendButton(
                        text: "Enviar",
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            Auth.sendPasswordResetEmail(
                              context: context,
                              navigatorKey: navigatorKey,
                              email: emailController.text.toString().trim(),
                            );
                            Utils.showAlert(
                              context,
                              navigatorKey,
                              "Recuperación de contraseña",
                              "Se ha enviado un correo a tu email para reestablecer la contraseña.",
                              "OK",
                              true,
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
