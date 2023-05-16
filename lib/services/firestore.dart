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
  String? uid,
  String? email,
  String? name,
  String? photoURL,
) async {
  await db.collection("users").doc(uid).set({
    "uid": uid,
    "username": "",
    "email": email,
    "name": name,
    "photoURL": photoURL,
    "signInMethod": "google",
  });
}

Future<void> saveUsername(String? uid, String? username) async {
  await db.collection("users").doc(uid).update({
    "username": username,
  });
}

Future<UserModel> getUserinfo(String uid) async {
  DocumentReference userDoc = db.collection("users").doc(uid);
  DocumentSnapshot documentSnapshot = await userDoc.get();

  Map<String, dynamic> userData =
      documentSnapshot.data() as Map<String, dynamic>;

  UserModel user = UserModel(
    uid: uid,
    username: userData["username"],
    email: userData["email"],
    photoURL: userData["photoURL"],
    signInMethod: userData["signInMethod"],
  );

  return user;
}

Future<bool> checkUsernameAvailability(String? username) async {
  QuerySnapshot querySnapshot =
      await db.collection('users').where('username', isEqualTo: username).get();
  return querySnapshot.docs.isEmpty;
}

Future<void> addPost(
  String uid,
  String username,
  String? mesasage,
  String? image,
) async {
  await db.collection("posts").doc().set({
    "uid": uid,
    "username": username,
    "message": mesasage,
    "iamges": image,
    "date": DateTime.now(),
  });
}
