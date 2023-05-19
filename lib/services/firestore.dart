import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_flic/models/user.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> saveMailUserInfo(String? uid, String? email) async {
  await db.collection("users").doc(uid).set({
    "uid": uid,
    "username": "",
    "email": email,
    "photoURL": "",
    "signInMethod": "mail",
  });
}

Future<void> saveGoogleUserInfo(
  String uid,
  String email,
  String name,
  String photoURL,
) async {
  final document =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (!document.exists) {
    await db.collection("users").doc(uid).set({
      "uid": uid,
      "username": "",
      "email": email,
      "name": name,
      "photoURL": photoURL,
      "signInMethod": "google",
    });
  }
}

Future<void> saveUsername(String? uid, String? username) async {
  await db.collection("users").doc(uid).update({
    "username": username,
  });
}

Future<UserModel> getUserinfo(String uid) async {
  DocumentSnapshot snapshot = await db.collection("users").doc(uid).get();

  if (snapshot.exists && snapshot.data() != null) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    UserModel user = UserModel(
      uid: data['uid'] as String,
      username: data['username'] as String,
      email: data['email'] as String,
      photoURL: data['photoURL'] as String,
      signInMethod: data['signInMethod'] as String,
    );

    return user;
  } else {
    throw StateError('No se encontró el documento o no se cargaron los datos');
  }
}

Future<String?> getUsernameFromFirestore(String uid) async {
  try {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      String? username = data['username'] as String?;
      return username;
    } else {
      return null;
    }
  } catch (e) {
    log('Error retrieving username from Firestore: $e');
    return null;
  }
}

Future<bool> checkUsernameAvailability(String? username) async {
  QuerySnapshot querySnapshot =
      await db.collection('users').where('username', isEqualTo: username).get();
  return querySnapshot.docs.isEmpty;
}

Future<void> addPost(
  String uid,
  String username,
  String photoURL,
  String? mesasage,
  String? image,
) async {
  await db.collection("posts").doc().set({
    "uid": uid,
    "username": username,
    "photoURL": photoURL,
    "message": mesasage,
    "image": image,
    "timestamp": Timestamp.now(),
  });
}
