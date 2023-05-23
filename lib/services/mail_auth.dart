import 'dart:developer';
import 'firestore.dart';
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
      Utils.showAlert(
        context,
        navigatorKey,
        "Error",
        "Las contraseñas no coinciden",
        "OK",
        false,
      );
      return;
    }

    Utils.showLoadingCircle(context);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      saveMailUserInfo(user.uid, email);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      navigatorKey.currentState!.pop();
      Utils.showAlert(
        context,
        navigatorKey,
        "Error",
        "El correo ingresado ya está registrado.",
        "OK",
        false,
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
      String message =
          "Un error inesperado ha ocurrido. Por favor intente más tarde.";

      if (e.code == "user-not-found") {
        message = "El correo no está registrado.";
      }
      if (e.code == "wrong-password") {
        message = "Correo y/o contraseña incorrectos.";
      }

      navigatorKey.currentState!.pop();
      Utils.showAlert(context, navigatorKey, "Error", message, "OK", false);
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
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log("Erorr: ${e.message}");
      navigatorKey.currentState!.pop();
    }
  }
}
