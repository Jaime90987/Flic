class UserModel {
  String? uid;
  String? username;
  String? name;
  String? email;
  String? photoURL;
  String? bio;
  String? signInMethod;
  int? postsNumber;

  UserModel({
    this.uid,
    this.username,
    this.name,
    this.email,
    this.photoURL,
    this.bio,
    this.signInMethod,
    this.postsNumber,
  });

  void updateData(
    String uid,
    String username,
    String name,
    String email,
    String photoURL,
    String bio,
    String signInMethod,
    int postsNumber,
  ) {
    this.uid = uid;
    this.username = username;
    this.name = name;
    this.email = email;
    this.photoURL = photoURL;
    this.bio = bio;
    this.signInMethod = signInMethod;
  }

  void setUid(String uid) {
    this.uid = uid;
  }

  void setUsername(String username) {
    this.username = username;
  }

  void setName(String name) {
    this.name = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPhotoURL(String photoURL) {
    this.photoURL = photoURL;
  }

  void setBio(String bio) {
    this.bio = bio;
  }

  void setSignInMethod(String signInMethod) {
    this.signInMethod = signInMethod;
  }

  void setPostsNumber(int postsNumber) {
    this.postsNumber = postsNumber;
  }
}
