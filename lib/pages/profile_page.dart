import 'package:flutter/material.dart';
import 'package:proyecto_flic/services/auth.dart';
import 'package:proyecto_flic/values/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
              icon: const Icon(Icons.logout),
              onPressed: () => Auth.signOut(),
              iconSize: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
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
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primary, width: 1.8),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: hasImage
                                ? const CircleAvatar(
                                    radius: 45,
                                    foregroundImage: AssetImage(
                                        "assets/images/profile_image.png"),
                                  )
                                : CircleAvatar(
                                    radius: 45,
                                    child: Text(
                                      Auth.user.email!.substring(0, 1),
                                      style: const TextStyle(
                                          fontSize: 72, height: 0.9),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _indicator("0", "Posts"),
                            const SizedBox(width: 30),
                            _indicator("10", "Followers"),
                            const SizedBox(width: 30),
                            _indicator("34", "Following"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 11,
                child: ListView.builder(
                  itemCount: 100,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Text("Post ${index + 1}");
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
