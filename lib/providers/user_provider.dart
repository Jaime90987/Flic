import 'package:flutter/material.dart';
import 'package:proyecto_flic/models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel();

  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
  }

  void setUsername(String username) {
    _user.setUsername(username);
  }

  void setName(String name) {
    _user.setName(name);
    notifyListeners();
  }

  void setBio(String bio) {
    _user.setBio(bio);
    notifyListeners();
  }

  void setPhotoURL(String photoURL) {
    _user.setPhotoURL(photoURL);
    notifyListeners();
  }

  void setPostsNumber(int postsNumber) {
    _user.setPostsNumber(postsNumber);
    notifyListeners();
  }
}
