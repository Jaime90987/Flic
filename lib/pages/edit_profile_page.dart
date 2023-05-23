import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto_flic/main.dart';
import 'package:proyecto_flic/pages/widgets/common/modal_image_options.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
import 'package:proyecto_flic/services/firestore.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:proyecto_flic/services/storage.dart';
import 'package:proyecto_flic/utils/utils_class.dart';
import 'package:proyecto_flic/values/colors.dart';

class EditProfilePage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const EditProfilePage({super.key, required this.navigatorKey});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? imageToUpload;
  String where = "";

  @override
  void dispose() {
    imageToUpload = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = context.read<UserProvider>().user.name.toString().trim();
    String bio = context.read<UserProvider>().user.bio.toString().trim();
    String actualPhotoURL =
        context.read<UserProvider>().user.photoURL.toString().trim();

    TextEditingController nameController =
        TextEditingController.fromValue(TextEditingValue(text: name));
    TextEditingController bioController =
        TextEditingController.fromValue(TextEditingValue(text: bio));

    void showLoadingCircle() {
      Utils.showLoadingCircle(context);
    }

    void updateProvider() {
      imageToUpload = null;
      context.read<UserProvider>().setPhotoURL(getUrl());
    }

    void updateName(String nameC) {
      context.read<UserProvider>().setName(nameC);
      saveName(Auth.user.uid, nameC);
    }

    void updateBio(bioC) {
      context.read<UserProvider>().setBio(bioC);
      saveBio(Auth.user.uid, bioC);
    }

    void close() {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }

    void saveChanges() async {
      String nameC = nameController.text.toString().trim();
      String bioC = bioController.text.toString().trim();

      if (imageToUpload != null) {
        showLoadingCircle();
        bool uploaded = await uploadImage(imageToUpload!);
        if (!uploaded) {
          log("Ocurrió un error al subir la imagen");
          return;
        }
        await savePhotoURL(Auth.user.uid, getUrl());
        updatePhotoURL(Auth.user.uid, actualPhotoURL, getUrl());
        actualPhotoURL = getUrl();
        updateProvider();
      }

      if (nameC != name) updateName(nameC);
      if (bioC != bio) updateBio(bioC);

      close();
    }

    void validateChanges() {
      String nameC = nameController.text.toString().trim();
      String bioC = bioController.text.toString().trim();

      if (nameC != name || bioC != bio || imageToUpload != null) {
        Utils.showConfirmAlert(
          context,
          navigatorKey,
          "Cambios sin guardar",
          "Tienes cambios sin guardar. ¿Estás seguro de que quieres descartar los cambios?",
          "No",
          "Sí",
          () => navigatorKey.currentState!.popUntil((route) => route.isFirst),
        );
      } else {
        Navigator.pop(context);
      }
    }

    Future<bool> confirmChanges() async {
      validateChanges();
      return true;
    }

    void checkWhere() {
      if (where == "appBar") {
        where = "";
        setState(() {});
        Navigator.pop(context);
      }
    }

    Future pickImage(ImageSource source) async {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;
        File? img = File(image.path);
        setState(() {
          imageToUpload = img;
          Navigator.pop(context);
        });
        checkWhere();
      } on PlatformException catch (e) {
        log(e.toString());
        Navigator.pop(context);
      }
    }

    void showFullScreenImage() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.black54,
              leading: Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                    semanticLabel: "Go Back",
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 12, 15, 12),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      where = "appBar";
                      setState(() {});
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return ModalImageOptions(onTap: pickImage);
                        },
                      );
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.pen,
                      color: Colors.white,
                      semanticLabel: "Edit",
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black54,
            body: PhotoView(
              imageProvider: NetworkImage(
                context.read<UserProvider>().user.photoURL.toString(),
              ),
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: confirmChanges,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Center(
            child: GestureDetector(
              onTap: validateChanges,
              child: const FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.black,
                semanticLabel: "Go Back",
              ),
            ),
          ),
          title: const Text(
            "Editar perfil",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 12, 15, 12),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: saveChanges,
                child: const FaIcon(
                  FontAwesomeIcons.check,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    imageToUpload == null
                        ? GestureDetector(
                            onTap: showFullScreenImage,
                            child: ProfileImage(
                              image: actualPhotoURL,
                              width: 130,
                              height: 130,
                            ),
                          )
                        : SizedBox(
                            width: 130,
                            height: 130,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.file(
                                imageToUpload!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    Container(
                      width: 140,
                      height: 130,
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ModalImageOptions(onTap: pickImage);
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.primary,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue:
                      context.read<UserProvider>().user.username.toString(),
                  decoration: const InputDecoration(
                    labelText: "Nombre de usuario",
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: bioController,
                  minLines: 1,
                  maxLines: 8,
                  maxLength: 150,
                  decoration: const InputDecoration(
                    labelText: "Presentación",
                    labelStyle: TextStyle(fontSize: 20),
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
