import 'package:flutter/material.dart';
import 'package:proyecto_flic/main.dart';
import 'package:proyecto_flic/pages/widgets/common/input_email.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:proyecto_flic/values/strings.dart';

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
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFB86B),
                      Color(0xFFFFAB52),
                      Color(0xFFC3FF85),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(AppStrings.loginImage, height: 150),
                      const SizedBox(height: 40),
                      InputEmail(emailController: emailController),
                      const SizedBox(height: 40),
                      SendButton(
                        text: "Enviar",
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            Auth.sendPasswordResetEmail(
                              context: context,
                              navigatorKey: navigatorKey,
                              email: emailController.text.toString().trim(),
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
