import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
import 'package:proyecto_flic/services/formated_date.dart';
import 'package:proyecto_flic/values/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "FLIC",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 12, 15, 12),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/chats"),
              child: const FaIcon(
                FontAwesomeIcons.solidMessage,
                color: AppColors.primary,
                semanticLabel: "Go to Chats",
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        child: Image.asset("assets/images/no_posts_yet.png"),
                      ),
                      const Text(
                        "Aún no hay ninguna publicación en Flic.",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: posts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final currentPost = posts[index];
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: ProfileImage(
                            image: currentPost['photoURL'].toString(),
                            width: 40,
                            height: 40,
                          ),
                          title: Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              if (currentPost['message'].toString().isNotEmpty)
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
                                    maxHeightDiskCache: 2000,
                                    imageUrl: currentPost['image'],
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey,
                                      height: 250,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        //SECCIÓN ME GUSTA Y COMENTARIOS
                        Container(
                          margin: const EdgeInsets.only(left: 60),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isLiked = !isLiked;
                                    final currentPost = posts[index];
                                    final postId = currentPost.id;
                                    final postRef = FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(postId);
                                    final newLikeCount = isLiked
                                        ? currentPost['likes'] + 1
                                        : currentPost['likes'] - 1;
                                    postRef.update({'likes': newLikeCount});
                                  });
                                },
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.comment_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              log(snapshot.error.toString());
              return Text('Error: ${snapshot.error}');
            } else {
              return const Text('No data');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addPost");
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
