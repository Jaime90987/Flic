import 'package:flutter/material.dart';
import 'package:proyecto_flic/models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel();

  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
    // notifyListeners();
  }

  void setUsername(String username) {
    _user.setUsername(username);
  }
}
