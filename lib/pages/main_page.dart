import 'package:flutter/material.dart';
import 'package:proyecto_flic/pages/home_page.dart';
import 'package:proyecto_flic/pages/profile_page.dart';
import 'package:proyecto_flic/values/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _currentPage = index;
          setState(() {});
        },
        currentIndex: _currentPage,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFFBA9FEE),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
