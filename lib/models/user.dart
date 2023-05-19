class UserModel {
  String? uid;
  String? username;
  String? email;
  String? photoURL;
  String? signInMethod;

  UserModel({
    this.uid,
    this.username,
    this.email,
    this.photoURL,
    this.signInMethod,
  });

  void updateData(
    String uid,
    String username,
    String email,
    String photoURL,
    String signInMethod,
  ) {
    this.uid = uid;
    this.username = username;
    this.email = email;
    this.photoURL = photoURL;
    this.signInMethod = signInMethod;
  }

  void setUid(String uid) {
    this.uid = uid;
  }

  void setUsername(String username) {
    this.username = username;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPhotoURL(String photoURL) {
    this.photoURL = photoURL;
  }

  void setSignInMethod(String signInMethod) {
    this.signInMethod = signInMethod;
  }
}
