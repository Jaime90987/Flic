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
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = Auth.user.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (timer) => checkEmailVerification(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(40, 220, 40, 0),
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
          ),
        );
}
