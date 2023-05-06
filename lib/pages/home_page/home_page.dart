import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_flic/pages/widgets/send_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(user!.email ?? "User email",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 15),
              Text(
                  "Correo validado: ${user.emailVerified.toString().toUpperCase()}",
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 50),
              SendButton(
                text: "Salir",
                function: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
