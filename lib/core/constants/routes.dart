import 'package:flutter/material.dart';
import 'package:kanban/features/auth/presentation/pages/auth_page.dart';
import 'package:kanban/features/kanban/presentation/pages/kanban_page.dart';
import 'package:kanban/features/user_settings/presentation/pages/user_settings_page.dart';
import 'package:kanban/app/pages/home_page.dart';
import 'package:kanban/app/root.dart';

class Routes {
  static const String root = '/root',
      homePage = '/home',
      kanbanPage = '/kanbanPage',
      authPage = '/authPage',
      settingsPage = '/settingsPage';

  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.root: (context) => const Root(),
    Routes.authPage: (context) => const AuthPage(),
    Routes.homePage: (context) => const HomePage(),
    Routes.kanbanPage: (context) => const KanbanPage(),
    Routes.settingsPage: (context) => const SettingsPage(),
  };
}
