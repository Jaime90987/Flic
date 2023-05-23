import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flic/pages/home_page.dart';
import 'package:proyecto_flic/pages/profile_page.dart';
import 'package:proyecto_flic/pages/search_page.dart';
import 'package:proyecto_flic/pages/widgets/common/profile_image.dart';
import 'package:proyecto_flic/providers/user_provider.dart';
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
    const SearchPage(),
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
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentPage,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFFBA9FEE),
        items: [
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            activeIcon: FaIcon(FontAwesomeIcons.house),
            label: "Inicio",
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: "Buscar",
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.all(2),
              child: ProfileImage(
                image: context.read<UserProvider>().user.photoURL ?? "",
                width: 30,
                height: 30,
              ),
            ),
            activeIcon: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(2),
                  child: ProfileImage(
                    image: context.read<UserProvider>().user.photoURL ?? "",
                    width: 30,
                    height: 30,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 30,
                  height: 30,
                ),
              ],
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
