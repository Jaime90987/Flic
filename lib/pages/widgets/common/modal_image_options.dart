import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_flic/values/colors.dart';

class ModalImageOptions extends StatelessWidget {
  final Function(ImageSource source) onTap;
  const ModalImageOptions({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      color: const Color(0xFF14171A),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onTap(ImageSource.camera);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    FaIcon(
                      FontAwesomeIcons.camera,
                      size: 45,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Cámara",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onTap(ImageSource.gallery);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    FaIcon(
                      FontAwesomeIcons.image,
                      size: 45,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Gallería",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
