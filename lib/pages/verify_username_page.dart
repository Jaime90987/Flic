import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/models/user.dart';
import 'package:proyecto_flic/pages/insert_username_page.dart';
import 'package:proyecto_flic/pages/main_page.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
import 'package:proyecto_flic/services/mail_auth.dart';

class VerifyUsernamePage extends StatefulWidget {
  const VerifyUsernamePage({super.key});

  @override
  State<VerifyUsernamePage> createState() => _VerifyUsernamePageState();
}

class _VerifyUsernamePageState extends State<VerifyUsernamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(Auth.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Algo salio mal..."));
          } else if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>?;

            if (data != null) {
              UserModel user = UserModel();

              UserProvider userProvider = Provider.of(context, listen: true);

              user.setUid(data['uid']);
              user.setName(data['name']);
              user.setEmail(data['email']);
              user.setPhotoURL(data['photoURL']);
              user.setSignInMethod(data['signInMethod']);
              user.setBio(data['bio']);
              user.setPostsNumber(data['postsNumber']);

              userProvider.setUser(user);

              if (data.containsKey("username") &&
                  data['username'].toString().isNotEmpty) {
                user.setUsername(data['username']);
                return const MainPage();
              } else {
                return const InsertUsernamePage();
              }
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
