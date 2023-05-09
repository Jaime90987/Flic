import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_flic/utils/utils_class.dart';

class Auth {
  static final user = FirebaseAuth.instance.currentUser!;

  static Future<void> createUserWithEmailAndPassword({
    required BuildContext context,
    required GlobalKey<NavigatorState> navigatorKey,
    required String email,
    required String password,
    required String cPassword,
  }) async {
    if (password != cPassword) {
      Utils.showAlert(context, "Error", "Las contraseñas no coinciden", "OK");
      return;
    }

    Utils.showLoadingCircle(context);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      navigatorKey.currentState!.pop();
      Utils.showAlert(
        context,
        "Error",
        "El correo ingresado ya está registrado.",
        "OK",
      );
    }
  }

  static Future<void> signInWithEmailAndPassword({
    required BuildContext context,
    required GlobalKey<NavigatorState> navigatorKey,
    required String email,
    required String password,
  }) async {
    Utils.showLoadingCircle(context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      navigatorKey.currentState!.pop();
      Utils.showAlert(
        context,
        "Error",
        "Correo y/o contraseña incorrectos o el correo no está registrado.",
        "OK",
      );
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> sendPasswordResetEmail({
    required BuildContext context,
    required GlobalKey<NavigatorState> navigatorKey,
    required String email,
  }) async {
    Utils.showLoadingCircle(context);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      log("Mail enviado");
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      navigatorKey.currentState!.pop();
    }
  }
}
