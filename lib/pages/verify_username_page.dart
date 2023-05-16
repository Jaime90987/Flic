import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/models/user.dart';
import 'package:proyecto_flic/pages/main_page.dart';
import 'package:proyecto_flic/pages/widgets/common/send_button.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
import 'package:proyecto_flic/services/firestore.dart';
import 'package:proyecto_flic/services/mail_auth.dart';
import 'package:proyecto_flic/values/colors.dart';

class VerifyUsernamePage extends StatefulWidget {
  const VerifyUsernamePage({super.key});

  @override
  State<VerifyUsernamePage> createState() => _VerifyUsernamePageState();
}

class _VerifyUsernamePageState extends State<VerifyUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();

  bool _usernameAvailable = true;
  bool _isLoading = true;

  void _validateUsername(String? value) async {
    if (value != null && value.isNotEmpty) {
      _usernameAvailable = await checkUsernameAvailability(value);
      setState(() {});
    }
  }

  void createUserModel() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel user = await getUserinfo(Auth.user.uid);
    userProvider.setUser(user);
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    createUserModel();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (context.read<UserProvider>().user.username != "") {
      return const MainPage();
    }
    return Scaffold(
      backgroundColor: Colors.white,
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
                  decoration: const InputDecoration(
                    labelText: "Nombre de Usuario",
                    labelStyle: TextStyle(color: AppColors.primary),
                    filled: true,
                    fillColor: Colors.white,
                    helperText: "",
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
                  },
                  validator: (value) {
                    if (value.toString().trim() == "" ||
                        value.toString().trim().isEmpty) {
                      return 'Por favor ingrese un nombre de usuario';
                    } else if (!_usernameAvailable) {
                      return 'Este nombre de usuario ya está en uso';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                SendButton(
                  text: "Aceptar",
                  function: () {
                    if (_formKey.currentState!.validate()) {
                      saveUsername(
                        Auth.user.uid,
                        userNameController.text.trim(),
                      );
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
