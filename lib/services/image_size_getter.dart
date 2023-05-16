import 'dart:io';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

double getImageAspectRatio(String imagePath) {
  final file = File(imagePath);
  final imageSize = ImageSizeGetter.getSize(FileInput(file));
  return imageSize.width / imageSize.height;
}

bool getImageRotate(String imagePath) {
  final file = File(imagePath);
  final imageSize = ImageSizeGetter.getSize(FileInput(file));
  return imageSize.needRotate;
}
