import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
import 'package:proyecto_flic/services/firestore.dart';
import 'package:proyecto_flic/services/mail_auth.dart';

class ModalPostOptions extends StatelessWidget {
  final String postId;
  final String message;
  final String imageURL;
  const ModalPostOptions({
    super.key,
    required this.postId,
    required this.message,
    required this.imageURL,
  });

  @override
  Widget build(BuildContext context) {
    int postsNumber =
        int.parse(context.read<UserProvider>().user.postsNumber.toString());
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 125,
      color: const Color(0xFF14171A),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Eliminar esta publicación"),
                      content: const Text(
                          "Esta acción no se podrá deshacer. ¿Estás seguro de que quieres eliminar la publicación?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            deletePost(postId, imageURL);
                            postsNumber = postsNumber - 1;
                            context
                                .read<UserProvider>()
                                .setPostsNumber(postsNumber);
                            savePostsNumber(Auth.user.uid, postsNumber);
                          },
                          child: const Text("Eliminar"),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    SizedBox(width: 15),
                    FaIcon(
                      FontAwesomeIcons.trash,
                      size: 25,
                      color: Color(0xFF657786),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Eliminar publicación",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => Navigator.popAndPushNamed(context, "/edit_post",
                    arguments: {
                      "postId": postId,
                      "message": message,
                      "imageURL": imageURL,
                    }),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    SizedBox(width: 15),
                    FaIcon(
                      FontAwesomeIcons.pen,
                      size: 25,
                      color: Color(0xFF657786),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Editar publicación",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
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
