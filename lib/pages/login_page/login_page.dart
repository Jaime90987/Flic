import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_flic/pages/widgets/input_email.dart';
import 'package:proyecto_flic/pages/widgets/input_password.dart';
import 'package:proyecto_flic/pages/widgets/send_button.dart';
import 'package:proyecto_flic/pages/widgets/footer.dart';
import 'package:proyecto_flic/pages/login_page/widgets/divider.dart';
import 'package:proyecto_flic/pages/login_page/widgets/forgot_password_message.dart';
import 'package:proyecto_flic/pages/login_page/widgets/social_networks.dart';
import 'package:proyecto_flic/values/strings.dart';

class LoginPage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const LoginPage({super.key, required this.navigatorKey});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
          child: Container(
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
                        labelText: AppStrings.passwordTextLabel,
                      ),
                      const SizedBox(height: 12),
                      const ForgotPasswordMessage(),
                      const SizedBox(height: 40),
                      SendButton(
                        text: AppStrings.loginText,
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            signInWithEmailAndPassword();
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      const MyDivider(),
                      const SizedBox(height: 30),
                      const SocialNetworks(),
                      const SizedBox(height: 30),
                      Footer(
                        message: AppStrings.dontHaveAnAccountYet,
                        message2: AppStrings.registerHere,
                        function: () =>
                            Navigator.pushNamed(context, "/register"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
