import 'package:flutter/material.dart';
import 'package:proyecto_flic/main.dart';
import 'package:proyecto_flic/pages/widgets/common/input_email.dart';
import 'package:proyecto_flic/pages/widgets/common/input_password.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/pages/widgets/common/footer.dart';
import 'package:proyecto_flic/pages/widgets/register_page/clip_path_register.dart';
import 'package:proyecto_flic/services/mail_auth.dart';

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
              const MyClipPathRegister(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset("assets/images/loginImage.png", height: 120),
                    const SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputEmail(emailController: emailController),
                          const SizedBox(height: 16),
                          InputPassword(
                            passwordController: passwordController,
                            labelText: "Contraseña",
                          ),
                          const SizedBox(height: 12),
                          InputPassword(
                            passwordController: confirmPasswordController,
                            labelText: "Confirmar contraseña",
                          ),
                          const SizedBox(height: 40),
                          SendButton(
                            text: "Registarse",
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
                          const SizedBox(height: 87),
                          Footer(
                            message: "¿Ya tienes una cuenta?",
                            message2: "Inicia sesión aquí",
                            function: () => Navigator.pop(context),
                          ),
                          const SizedBox(height: 10),
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
