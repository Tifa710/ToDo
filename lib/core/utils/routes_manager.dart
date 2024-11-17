import 'package:flutter/material.dart';
import 'package:todo/presetation/screens/auth/login/login.dart';
import 'package:todo/presetation/screens/auth/register/register.dart';
import 'package:todo/presetation/screens/home/home_screen.dart';
import 'package:todo/presetation/screens/splash/splash_screen.dart';
import 'package:todo/presetation/screens/task_edit/task_edit.dart';

class RoutesManager {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String register = '/register';
  static const String login = '/login';
  static const String task_edit = '/task_edit';

  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      case splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case register:
        return MaterialPageRoute(
          builder: (context) => const Register(),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );
      case task_edit:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => TaskEdit(),
        );
    }
  }
}
