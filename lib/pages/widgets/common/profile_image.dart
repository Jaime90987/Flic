import 'package:flutter/material.dart';
import 'package:proyecto_flic/values/colors.dart';

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
      borderRadius: BorderRadius.circular(50),
      child: image != ""
          ? Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.primary,
              ),
              child: Image.network(image, fit: BoxFit.cover),
            )
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.asset("assets/images/avatar-none.png"),
            ),
    );
  }
}
