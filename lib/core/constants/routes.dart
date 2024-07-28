import 'package:flutter/material.dart';
import 'package:kanban/core/auth/pages/login_page.dart';
import 'package:kanban/features/kanban/presentation/pages/kanban_page.dart';
import 'package:kanban/home_page.dart';
import 'package:kanban/root.dart';

class Routes {
  static const String root = '/root',
      homePage = '/home',
      kanbanPage = '/kanbanPage',
      authPage = '/authPage';

  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.root: (context) => const Root(),
    Routes.authPage: (context) => const AuthPage(),
    Routes.homePage: (context) => const HomePage(),
    Routes.kanbanPage: (context) => const KanbanPage(),
  };
}
