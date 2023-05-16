import 'package:flutter/material.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool hasImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Auth.user.email ?? "User email",
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Auth.signOut(),
              iconSize: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: GestureDetector(
                          onTap: () {},
                          child: hasImage
                              ? const CircleAvatar(
                                  radius: 40,
                                  foregroundImage: AssetImage(
                                      "assets/images/profile_image.png"),
                                )
                              : CircleAvatar(
                                  radius: 40,
                                  child: Text(
                                    Auth.user.email!.substring(0, 1),
                                    style: const TextStyle(
                                        fontSize: 72, height: 0.9),
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _indicator("0", "Publicaciones"),
                            const SizedBox(width: 30),
                            _indicator("10", "Seguidores"),
                            const SizedBox(width: 30),
                            _indicator("34", "Siguiendo"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 11,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: Auth.user.uid) // Solo se muestran los posts del usuario que ha iniciado sesión
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      final posts = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: posts.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final currentPost = posts[index];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      currentPost['iamges']),
                                ),
                                title: Text(currentPost['username']),
                                subtitle: Column(
                                  children: <Widget>[
                                    const SizedBox(height: 10),
                                    Text(currentPost['message']),
                                    const SizedBox(height: 10),
                                    Text("${DateTime.fromMillisecondsSinceEpoch(currentPost['date'].millisecondsSinceEpoch)}",),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _indicator(String number, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(text),
      ],
    );
  }
}