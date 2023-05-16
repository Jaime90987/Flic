import 'package:flutter/material.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
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
            child: const ProfileImage(width: 33, height: 33),
          ),
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(),
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
