import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
String url = "";

String getUrl() {
  return url;
}

Future<bool> uploadImage(File image) async {
  final String nameFile = image.path.split("/").last;
  final Reference reference =
      storage.ref().child("posts_images").child(nameFile);
  final UploadTask uploadTask = reference.putFile(image);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  url = await snapshot.ref.getDownloadURL();
  return snapshot.state == TaskState.success;
}
