class UserModel {
  String uid;
  String username;
  String email;
  String photoURL;
  String signInMethod;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoURL,
    required this.signInMethod,
  });
}
