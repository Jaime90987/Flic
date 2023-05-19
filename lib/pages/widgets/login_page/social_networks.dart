// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proyecto_flic/services/google_auth.dart';
import 'package:proyecto_flic/values/strings.dart';

class SocialNetworks extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const SocialNetworks({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialNetworkTemplate(
            AppStrings.socialImage1, AppStrings.socialText1, context),
      ],
    );
  }

  ElevatedButton _socialNetworkTemplate(
      String asset, String label, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await GoogleAuth.registerWithGoogle(
          context: context,
          navigatorKey: navigatorKey,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: SvgPicture.asset(
        asset,
        height: 50,
        semanticsLabel: label,
      ),
    );
  }
}
