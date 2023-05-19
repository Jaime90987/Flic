import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_flic/services/firestore.dart';
import 'package:proyecto_flic/utils/utils_class.dart';

class GoogleAuth {
  static Future<User?> registerWithGoogle({
    required BuildContext context,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      Utils.showLoadingCircle(context);
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      saveGoogleUserInfo(
        userCredential.user!.uid,
        userCredential.user!.email!,
        userCredential.user!.displayName!,
        userCredential.user!.photoURL!,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return null;
    }
  }

  static Future<void> signOutGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
