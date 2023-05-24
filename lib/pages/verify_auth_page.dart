import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_flic/pages/login_page.dart';
import 'package:proyecto_flic/pages/veriry_email_page.dart';
import 'package:proyecto_flic/values/colors.dart';

class VerifyAuthPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const VerifyAuthPage({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Algo salio mal..."));
          } else if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else {
            return LoginPage(navigatorKey: navigatorKey);
          }
        },
      ),
    );
  }
}
