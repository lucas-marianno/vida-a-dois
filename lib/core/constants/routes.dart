import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/presentation/pages/kanban_page.dart';
import 'package:kanban/home_page.dart';

class Routes {
  static const String homePage = '/main', kanbanPage = '/kanbanPage';

  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.homePage: (context) => const HomePage(),
    Routes.kanbanPage: (context) => const KanbanPage(),
  };
}
