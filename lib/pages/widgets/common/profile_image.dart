import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  const ProfileImage({
    super.key,
    required this.width,
    required this.height,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: image != ""
          ? Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey,
              ),
              child: Image.network(image, fit: BoxFit.cover),
            )
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset("assets/images/avatar-none.png"),
            ),
    );
  }
}
