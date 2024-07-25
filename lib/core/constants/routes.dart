import 'package:flutter/material.dart';
import 'package:kanban/features/auth/presentation/pages/login_page.dart';
import 'package:kanban/features/auth/presentation/pages/signin_page.dart';
import 'package:kanban/features/kanban/presentation/pages/kanban_page.dart';
import 'package:kanban/home_page.dart';

class Routes {
  static const String homePage = '/main',
      kanbanPage = '/kanbanPage',
      loginPage = '/loginPage',
      signInPage = '/signInPage';

  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.homePage: (context) => const HomePage(),
    Routes.kanbanPage: (context) => const KanbanPage(),
    Routes.loginPage: (context) => const LoginPage(),
    Routes.signInPage: (context) => const SigninPage(),
  };
}
