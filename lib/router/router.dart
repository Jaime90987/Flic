import 'package:flutter/material.dart';
import 'package:proyecto_flic/pages/forgot_password_page/forgot_password.dart';
import 'package:proyecto_flic/pages/main_page/main_page.dart';
import 'package:proyecto_flic/pages/login_page/login_page.dart';
import 'package:proyecto_flic/pages/register_page/register_page.dart';
import 'package:proyecto_flic/pages/home_page/home_page.dart';

Map<String, WidgetBuilder> routes(GlobalKey<NavigatorState> navigatorKey) {
  return {
    '/': (_) => MainPage(navigatorKey: navigatorKey),
    '/login': (_) => LoginPage(navigatorKey: navigatorKey),
    '/register': (_) => RegisterPage(navigatorKey: navigatorKey),
    '/forgot_password': (_) => ForgotPasswordPage(navigatorKey: navigatorKey),
    '/home': (_) => const HomePage(),
  };
}
