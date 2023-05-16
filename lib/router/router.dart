import 'package:flutter/material.dart';
import 'package:proyecto_flic/pages/add_post_page.dart';
import 'package:proyecto_flic/pages/profile_page.dart';
import 'package:proyecto_flic/pages/search_page.dart';
import 'package:proyecto_flic/pages/verify_auth_page.dart';
import 'package:proyecto_flic/pages/login_page.dart';
import 'package:proyecto_flic/pages/register_page.dart';
import 'package:proyecto_flic/pages/forgot_password_page.dart';
import 'package:proyecto_flic/pages/main_page.dart';
import 'package:proyecto_flic/pages/home_page.dart';

Map<String, WidgetBuilder> routes(GlobalKey<NavigatorState> navigatorKey) {
  return {
    '/': (_) => VerifyAuthPage(navigatorKey: navigatorKey),
    '/login': (_) => LoginPage(navigatorKey: navigatorKey),
    '/register': (_) => RegisterPage(navigatorKey: navigatorKey),
    '/forgot_password': (_) => ForgotPasswordPage(navigatorKey: navigatorKey),
    '/main': (_) => const MainPage(),
    '/home': (_) => const HomePage(),
    '/search': (_) => const SearchPage(),
    '/profile': (_) => const ProfilePage(),
    '/addPost': (_) => AddPostPage(navigatorKey: navigatorKey),
  };
}
