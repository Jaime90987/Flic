import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
import 'package:proyecto_flic/pages/widgets/profile_page/modal_post_options.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
import 'package:proyecto_flic/services/formated_date.dart';
import 'package:proyecto_flic/services/google_auth.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final photoURL = context.watch<UserProvider>().user.photoURL.toString();
    final postsNumber =
        context.watch<UserProvider>().user.postsNumber.toString();

    final name = context.watch<UserProvider>().user.name.toString();
    final bio = context.watch<UserProvider>().user.bio.toString();

    void showFullScreenImage() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.black54,
            ),
            backgroundColor: Colors.black54,
            body: PhotoView(imageProvider: NetworkImage(photoURL)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<UserProvider>().user.username.toString(),
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton(
            icon: const FaIcon(FontAwesomeIcons.bars),
            onSelected: (value) {
              if (value == "edit") {
                Navigator.pushNamed(context, "/edit_profile");
              } else if (value == "logout") {
                if (context.read<UserProvider>().user.signInMethod.toString() ==
                    "google") {
                  GoogleAuth.signOutGoogle();
                } else {
                  Auth.signOut();
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: "edit",
                child: Text("Editar perfil"),
              ),
              const PopupMenuItem(
                value: "logout",
                child: Text("Cerrar sesión"),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: showFullScreenImage,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 8, 0, 0),
                      child: ProfileImage(
                        image: photoURL,
                        width: 77,
                        height: 77,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 25, 0),
                    child: Row(
                      children: <Widget>[
                        _indicator(postsNumber.toString(), "Publicaciones"),
                        const SizedBox(width: 10),
                        _indicator("0", "Seguidores"),
                        const SizedBox(width: 10),
                        _indicator("0", "Siguiendo"),
                      ],
                    ),
                  ),
                ],
              ),
              if (name != "" || bio != "")
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 5, 20, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (name != "")
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            const SizedBox(height: 5),
                            if (bio != "")
                              Text(
                                bio,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: Auth.user.uid)
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final posts = snapshot.data!.docs;

                    if (posts.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(50),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child:
                                  Image.asset("assets/images/no_posts_yet.png"),
                            ),
                            const Text(
                              "Aún no has hecho ninguna publicación.",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final currentPost = posts[index];
                        return Card(
                          child: ListTile(
                            leading: ProfileImage(
                              image: currentPost["photoURL"],
                              width: 40,
                              height: 40,
                            ),
                            title: Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      currentPost['username'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    getFormattedDate(currentPost["timestamp"]),
                                    textAlign: TextAlign.right,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ModalPostOptions(
                                            postId: currentPost.id.toString(),
                                            message: currentPost["message"]
                                                .toString(),
                                            imageURL:
                                                currentPost["image"].toString(),
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.more_vert),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                if (currentPost['message']
                                    .toString()
                                    .isNotEmpty)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      currentPost['message'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                if (currentPost['image'].toString() != "")
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: currentPost['image'],
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey,
                                        height: 250,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container(
                      margin: const EdgeInsets.only(top: 200),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    log(snapshot.error.toString());
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Text('No data');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _indicator(String number, String text) {
    return SizedBox(
      height: 77,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            number,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
