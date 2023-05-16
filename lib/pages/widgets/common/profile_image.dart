import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
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
      child: context.read<UserProvider>().user.photoURL.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              width: width,
              height: height,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.person),
              ),
            )
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.primary,
              ),
              child: const Icon(Icons.person, color: Colors.white),
            ),
    );
  }
}
