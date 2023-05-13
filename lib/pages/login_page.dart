import 'package:flutter/material.dart';
import 'package:proyecto_flic/main.dart';
import 'package:proyecto_flic/pages/widgets/common/footer.dart';
import 'package:proyecto_flic/pages/widgets/common/input_email.dart';
import 'package:proyecto_flic/pages/widgets/common/input_password.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/pages/widgets/login_page/divider.dart';
import 'package:proyecto_flic/pages/widgets/login_page/forgot_password_message.dart';
import 'package:proyecto_flic/pages/widgets/login_page/social_networks.dart';
import 'package:proyecto_flic/services/auth.dart';
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                          const ForgotPasswordMessage(),
                          const SizedBox(height: 40),
                          SendButton(
                            text: AppStrings.loginText,
                            function: () {
                              if (_formKey.currentState!.validate()) {
                                Auth.signInWithEmailAndPassword(
                                  context: context,
                                  navigatorKey: navigatorKey,
                                  email: emailController.text.toString().trim(),
                                  password:
                                      passwordController.text.toString().trim(),
                                );
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
            ],
          ),
        ),
      ),
    );
  }
}
