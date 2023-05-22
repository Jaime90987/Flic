import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/main.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
import 'package:proyecto_flic/services/firestore.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:proyecto_flic/services/select_image.dart';
import 'package:proyecto_flic/services/storage.dart';
import 'package:proyecto_flic/utils/utils_class.dart';
import 'package:proyecto_flic/values/colors.dart';

class AddPostPage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const AddPostPage({super.key, required this.navigatorKey});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final messageController = TextEditingController();
  File? imageToUpload;
  double width = 0;
  double height = 0;

  @override
  void dispose() {
    messageController.dispose();
    imageToUpload = null;
    super.dispose();
  }

  void _showFullScreenImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.black54,
          ),
          backgroundColor: Colors.black54,
          body: PhotoView(imageProvider: FileImage(imageToUpload!)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = context.read<UserProvider>().user.username;
    final photoURL = context.read<UserProvider>().user.photoURL;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Crear una publicación",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();

                Utils.showLoadingCircle(context);

                if (messageController.text.toString().isEmpty &&
                    imageToUpload == null) {
                  Utils.showAlert(
                    context,
                    navigatorKey,
                    "Error al crear la publicación",
                    "La publicación debe contener al menos un mensaje o una imagen.",
                    "OK",
                    false,
                  );
                  return;
                }

                if (imageToUpload != null) {
                  bool uploaded = await uploadImage(imageToUpload!);
                  if (!uploaded) {
                    log("Ocurrió un error al subir la imagen");
                    return;
                  }
                }

                await addPost(
                  Auth.user.uid,
                  username.toString(),
                  photoURL.toString(),
                  messageController.text.toString().trim(),
                  imageToUpload != null ? getUrl() : "",
                );

                imageToUpload = null;
                messageController.text = "";
                setState(() {});
                navigatorKey.currentState!.popUntil((route) => route.isFirst);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.primary),
              ),
              child: const Text(
                "Publicar",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.fromLTRB(18, 10, 18, 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(children: [
                      ProfileImage(
                        image: context
                            .read<UserProvider>()
                            .user
                            .photoURL
                            .toString(),
                        width: 40,
                        height: 40,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            username.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> map = await getValues(imageToUpload);
                      width = map["width"] ?? 0;
                      height = map["height"] ?? 0;
                      imageToUpload = map["image"];
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.image_outlined,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  )
                ],
              ),
              TextField(
                controller: messageController,
                maxLines: 12,
                minLines: 1,
                maxLength: 300,
                autofocus: true,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "¿En que estas pensando?",
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFB2AEAE)),
                  counterText: "",
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * width,
                  height: MediaQuery.of(context).size.width * height,
                  child: imageToUpload != null
                      ? GestureDetector(
                          onTap: _showFullScreenImage,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.file(
                                imageToUpload!,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    imageToUpload = null;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: const Color(0xDBF6F4F4),
                                    ),
                                    child: SvgPicture.asset(
                                        "assets/icons/cancel.svg"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
