import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
import 'package:proyecto_flic/services/firestore.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:proyecto_flic/values/colors.dart';

class InsertUsernamePage extends StatefulWidget {
  const InsertUsernamePage({Key? key}) : super(key: key);

  @override
  State<InsertUsernamePage> createState() => _InsertUsernamePageState();
}

class _InsertUsernamePageState extends State<InsertUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  bool _usernameAvailable = false;
  String _username = '';

  Future<void> _validateUsername(String? value) async {
    if (value != null && value.isNotEmpty) {
      _usernameAvailable = await checkUsernameAvailability(value);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "¿Quién eres?",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "Por favor escribe un nombre de usuario para identificarte en Flic.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: userNameController,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    labelText: "Nombre de Usuario",
                    labelStyle: TextStyle(color: AppColors.primary),
                    filled: true,
                    fillColor: Colors.white,
                    helperText: "",
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    prefixIcon: Icon(Icons.person),
                    prefixIconColor: AppColors.primary,
                  ),
                  onChanged: (value) {
                    _validateUsername(value.toString().trim());
                    _username = value.toString().trim();
                  },
                  validator: (value) {
                    if (value.toString().trim() == "" ||
                        value.toString().trim().isEmpty) {
                      return 'Por favor ingrese un nombre de usuario';
                    } else if (value.toString().length < 4) {
                      return 'El nombre de usuario debe tener al menos 4 caracteres';
                    } else if (!_usernameAvailable) {
                      return 'Este nombre de usuario ya está en uso';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                SendButton(
                  text: "Aceptar",
                  function: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<UserProvider>().setUsername(_username);
                      saveUsername(Auth.user.uid, _username);
                      Navigator.pushReplacementNamed(context, "/main");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
