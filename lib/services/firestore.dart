import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> saveMailUserInfo(String? uid, String? email) async {
  await db.collection("users").doc(uid).set({
    "username": "",
    "email": email,
    "signInMethod": "mail",
  });
}

Future<void> saveGoogleUserInfo(
    String? uid, String? email, String? name, String? photoURL) async {
  await db.collection("users").doc(uid).set({
    "username": "",
    "email": email,
    "photoURL": photoURL,
    "signInMethod": "google",
  });
}

Future<void> saveUsername(String? uid, String? username) async {
  await db.collection("users").doc(uid).update({
    "username": username,
  });
}

Future<Object> getUserinfo(String uid) async {
  DocumentReference userDoc = db.collection("users").doc(uid);
  DocumentSnapshot documentSnapshot = await userDoc.get();
  return documentSnapshot;
}

Future<String> getUsername(String uid) async {
  DocumentSnapshot userDoc = await db.collection('users').doc(uid).get();
  return userDoc.get('username').toString();
}

Future<bool> checkUsernameAvailability(String? username) async {
  QuerySnapshot querySnapshot =
      await db.collection('users').where('username', isEqualTo: username).get();
  log("1 funcion ${querySnapshot.docs.isEmpty.toString()}");
  return querySnapshot.docs.isEmpty;
}
