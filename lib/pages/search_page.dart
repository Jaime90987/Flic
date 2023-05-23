import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_flic/models/user_search.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:proyecto_flic/pages/other_profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<UserSearch> allUsers = [];
  List<UserSearch> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isNotEqualTo: Auth.user.uid)
        .get();

    final users = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return UserSearch(
        uid: data['uid'],
        username: data['username'],
        email: data['email'],
        photoURL: data['photoURL'],
      );
    }).toList();

    setState(() {
      allUsers = users;
      filteredUsers = users;
    });
  }

  void filterUsers(String keyword) {
    setState(() {
      filteredUsers = allUsers.where((user) {
        final username = user.username.toLowerCase();
        return username.contains(keyword.toLowerCase());
      }).toList();
    });
  }

  void navigateToOtherProfilePage(UserSearch user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherProfilePage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          cursorColor: Colors.black54,
          maxLines: 1,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              size: 22,
            ),
            prefixIconColor: Colors.black54,
            hintText: 'Search by username',
            filled: true,
            fillColor: Colors.grey,
            contentPadding: EdgeInsets.all(0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          onChanged: (value) {
            filterUsers(value);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return ListTile(
                  onTap: () => navigateToOtherProfilePage(user),
                  leading:
                      ProfileImage(image: user.photoURL, width: 40, height: 40),
                  title: Text(user.username),
                  subtitle: Text(user.email),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
