import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_flic/pages/widgets/input_email.dart';
import 'package:proyecto_flic/pages/widgets/input_password.dart';
import 'package:proyecto_flic/pages/widgets/send_button.dart';
import 'package:proyecto_flic/pages/widgets/footer.dart';
import 'package:proyecto_flic/values/strings.dart';

class RegisterPage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const RegisterPage({super.key, required this.navigatorKey});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (passwordController.text.toString() !=
        confirmPasswordController.text.trim().toString()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      widget.navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      widget.navigatorKey.currentState!.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Image.asset(AppStrings.loginImage, height: 150),
                    const SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputEmail(emailController: emailController),
                          const SizedBox(height: 16),
                          InputPassword(
                              passwordController: passwordController,
                              labelText: AppStrings.passwordTextLabel),
                          const SizedBox(height: 12),
                          InputPassword(
                            passwordController: confirmPasswordController,
                            labelText: AppStrings.confirmPasswordTextLabel,
                          ),
                          const SizedBox(height: 40),
                          SendButton(
                            text: AppStrings.signUpText,
                            function: () {
                              if (_formKey.currentState!.validate()) {
                                createUserWithEmailAndPassword();
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          Footer(
                            message: AppStrings.alreadyHaveAnAccount,
                            message2: AppStrings.loginHere,
                            function: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
