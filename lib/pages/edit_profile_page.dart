import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
import 'package:proyecto_flic/providers/user_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  void _selectImage() {}

  void _saveChanges() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Editar perfil",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _selectImage,
                child: ProfileImage(
                  image: context.read<UserProvider>().user.photoURL ?? "",
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: context.read<UserProvider>().user.username,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                ),
                onChanged: (value) {
                  // setState(() {
                  //   _name = value;
                  // });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: "",
                decoration: const InputDecoration(
                  labelText: "Presentación",
                ),
                onChanged: (value) {
                  // setState(() {
                  //   "" = value;
                  // });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
