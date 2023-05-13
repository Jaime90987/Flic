import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_flic/pages/verify_username_page.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/services/mail_auth.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    isEmailVerified = Auth.user.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      Timer.periodic(
        const Duration(seconds: 3),
        (timer) => checkEmailVerification(),
      );
    }
  }

  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    setState(() {});
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const VerifyUsernamePage()
      : Scaffold(
          body: SafeArea(
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Se ha enviado un correo de verificación a tu email.",
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      SendButton(
                        text: "Cancelar",
                        function: () => Auth.signOut(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
}
