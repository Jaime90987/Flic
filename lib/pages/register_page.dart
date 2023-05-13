import 'package:flutter/material.dart';
import 'package:proyecto_flic/main.dart';
import 'package:proyecto_flic/pages/widgets/common/input_email.dart';
import 'package:proyecto_flic/pages/widgets/common/input_password.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/pages/widgets/common/footer.dart';
import 'package:proyecto_flic/services/auth.dart';
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
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      Color(0xFF87CEFA),
                      Color(0xFF6FD5E3),
                      Color(0xFF7CFDE9),
                    ],
                  ),
                ),
              ),
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
                            labelText: AppStrings.passwordTextLabel,
                          ),
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
                                Auth.createUserWithEmailAndPassword(
                                  context: context,
                                  navigatorKey: navigatorKey,
                                  email: emailController.text.toString().trim(),
                                  password:
                                      passwordController.text.toString().trim(),
                                  cPassword: confirmPasswordController.text
                                      .toString()
                                      .trim(),
                                );
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
