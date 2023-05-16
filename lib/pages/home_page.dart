import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
import 'package:proyecto_flic/services/formated_date.dart';
import 'package:proyecto_flic/values/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "FLIC",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 12, 15, 12),
            child: ProfileImage(
              image: context.read<UserProvider>().user.photoURL,
              width: 33,
              height: 33,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy("date", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              getFormatedDate(currentPost["date"]),
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
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (currentPost['image'].toString() != "")
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(currentPost['image']),
                            ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
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
