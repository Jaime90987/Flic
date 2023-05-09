import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_flic/pages/widgets/common/input_email.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';

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

  Future sendPasswordResetEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      log("Mail enviado");
      widget.navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      widget.navigatorKey.currentState!.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Center(child: Text("hello There")),
                  const SizedBox(height: 40),
                  InputEmail(emailController: emailController),
                  const SizedBox(height: 40),
                  SendButton(
                    text: "Enviar",
                    function: () {
                      if (_formKey.currentState!.validate()) {
                        sendPasswordResetEmail();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
