import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_flic/services/image_size_getter.dart';

Future<Map<String, dynamic>> getValues(File? imageToUpload) async {
  double width = 1;
  double height = 1;

  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  imageToUpload = File(image!.path);

  double aspectRatio = getImageAspectRatio(image.path);
  final rotate = getImageRotate(image.path);
  aspectRatio = double.parse(aspectRatio.toStringAsFixed(2));

  if (aspectRatio >= 0.88 && aspectRatio <= 1.22) {
    width = 0.78;
    height = 0.78;
  } else if ((aspectRatio == 1.77 && !rotate) ||
      (aspectRatio > 1.77 && rotate) ||
      (aspectRatio < 0.88 && rotate) ||
      aspectRatio <= 0.60) {
    width = 0.6;
    height = 1;
  } else if ((aspectRatio == 1.77 && rotate) ||
      (aspectRatio > 1.77 && !rotate)) {
    width = 1;
    height = 0.5;
  } else if (aspectRatio < 0.88 && aspectRatio > 0.60 && !rotate) {
    width = 0.7;
    height = 0.9;
  }

  return {"width": width, "height": height, "image": imageToUpload};
}
