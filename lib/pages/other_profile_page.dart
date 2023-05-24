import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:proyecto_flic/models/user_search.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
import 'package:proyecto_flic/services/aes_crytor.dart';
import 'package:proyecto_flic/services/formated_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_flic/values/colors.dart';

class OtherProfilePage extends StatefulWidget {
  final UserSearch user;

  const OtherProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  int postsNumber = 0;

  void showFullScreenImage(String image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.black54,
          ),
          backgroundColor: Colors.black54,
          body: PhotoView(imageProvider: NetworkImage(image)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.username.toString(),
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black,
              semanticLabel: "Go Back",
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid', isEqualTo: widget.user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final userDocs = snapshot.data?.docs;
                  if (snapshot.hasData) {
                    final userData = userDocs!.first.data();
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () =>
                                  showFullScreenImage(widget.user.photoURL),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child: ProfileImage(
                                  image: widget.user.photoURL,
                                  width: 77,
                                  height: 77,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 25, 0),
                              child: Row(
                                children: <Widget>[
                                  _indicator(userData["postsNumber"].toString(),
                                      "Publicaciones"),
                                  const SizedBox(width: 10),
                                  _indicator("0", "Seguidores"),
                                  const SizedBox(width: 10),
                                  _indicator("0", "Siguiendo"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (userData["name"].toString() != "" ||
                            userData["bio"].toString() != "")
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 5, 20, 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (userData["name"].toString() != "")
                                        Text(
                                          userData["name"].toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      const SizedBox(height: 5),
                                      if (userData["bio"].toString() != "")
                                        Text(
                                          userData["bio"].toString(),
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
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: widget.user.uid)
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
                              child: Image.asset(
                                "assets/images/no_posts_yet.png",
                              ),
                            ),
                            const Text(
                              "Aún no hay ninguna publicación.",
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
                        String photo = "";

                        if (currentPost['photoURL'].toString().isEmpty) {
                          photo = currentPost['photoURL'];
                        } else {
                          photo = AESCryptor.decrypt(
                              currentPost['photoURL'].toString());
                        }
                        return Card(
                          child: ListTile(
                            leading: ProfileImage(
                              image: photo,
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    getFormattedDate(currentPost["timestamp"]),
                                    textAlign: TextAlign.right,
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
                                  GestureDetector(
                                    onTap: () => showFullScreenImage(
                                        currentPost['image'].toString()),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: currentPost['image'],
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Colors.grey,
                                          height: 250,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
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
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
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
