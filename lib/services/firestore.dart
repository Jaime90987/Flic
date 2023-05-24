import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_flic/services/aes_crytor.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> saveMailUserInfo(String? uid, String? email) async {
  await db.collection("users").doc(uid).set({
    "uid": uid,
    "username": "",
    "name": "",
    "email": AESCryptor.encrypt(email.toString()),
    "bio": "",
    "photoURL": "",
    "signInMethod": "mail",
    "postsNumber": 0,
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
      "name": "",
      "email": AESCryptor.encrypt(email.toString()),
      "bio": "",
      "photoURL": AESCryptor.encrypt(photoURL.toString()),
      "signInMethod": "google",
      "postsNumber": 0,
    });
  }
}

Future<void> saveUsername(String? uid, String? username) async {
  await db.collection("users").doc(uid).update({
    "username": username,
  });
}

Future<void> saveName(String? uid, String? name) async {
  await db.collection("users").doc(uid).update({
    "name": name.toString(),
  });
}

Future<void> saveBio(String? uid, String? bio) async {
  await db.collection("users").doc(uid).update({
    "bio": bio.toString(),
  });
}

Future<void> savePhotoURL(String? uid, String? photoURL) async {
  await db.collection("users").doc(uid).update({
    "photoURL": AESCryptor.encrypt(photoURL.toString()),
  });
}

Future<void> updatePhotoURL(
    String uid, String odlPhotoURL, String newPhotoURL) async {
  QuerySnapshot querySnapshot = await db
      .collection("posts")
      .where("photoURL", whereIn: [odlPhotoURL, ""]).get();

  for (var doc in querySnapshot.docs) {
    db.collection("posts").doc(doc.id).update({
      'photoURL': AESCryptor.encrypt(newPhotoURL.toString()),
    });
  }
}

Future<void> savePostsNumber(String? uid, int postsNumber) async {
  await db.collection("users").doc(uid).update({
    "postsNumber": postsNumber,
  });
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
    "likes": 0,
    "isLiked": false,
    "timestamp": Timestamp.now(),
  });
}

Future<void> updatePost(
  String id,
  String uid,
  String username,
  String photoURL,
  String mesasage,
  String image,
) async {
  await db.collection("posts").doc(id).update({
    "uid": uid,
    "username": username,
    "photoURL": AESCryptor.encrypt(photoURL.toString()),
    "message": mesasage,
    "image": image,
    "timestamp": Timestamp.now(),
  });
}

Future<void> deletePost(String id, String imageURL) async {
  await db.collection("posts").doc(id).delete();
  if (imageURL == "") return;
  FirebaseStorage.instance.refFromURL(imageURL).delete();
}
