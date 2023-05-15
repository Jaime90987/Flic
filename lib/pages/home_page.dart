import 'package:flutter/material.dart';
import 'package:proyecto_flic/values/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[Container()],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),
    );
  }
}
