import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_flic/main.dart';
import 'package:proyecto_flic/pages/widgets/common/footer.dart';
import 'package:proyecto_flic/pages/widgets/common/input_email.dart';
import 'package:proyecto_flic/pages/widgets/common/input_password.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/pages/widgets/login_page/clip_path_login.dart';
import 'package:proyecto_flic/pages/widgets/login_page/divider.dart';
import 'package:proyecto_flic/pages/widgets/login_page/forgot_password_message.dart';
import 'package:proyecto_flic/services/google_auth.dart';
import 'package:proyecto_flic/services/mail_auth.dart';

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
              const MyClipPathLogin(),
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
                          const ForgotPasswordMessage(),
                          const SizedBox(height: 40),
                          SendButton(
                            text: "Iniciar sesión",
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
                          ElevatedButton(
                            onPressed: () async {
                              await GoogleAuth.registerWithGoogle(
                                context: context,
                                navigatorKey: navigatorKey,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 48),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.all(8),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/icons/google.svg",
                                  height: 32,
                                  semanticsLabel: "Google",
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  "Ingresar con Google",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Footer(
                            message: "¿Aún no tienes una cuenta?",
                            message2: "Registrate aquí",
                            function: () =>
                                Navigator.pushNamed(context, "/register"),
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
