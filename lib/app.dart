import 'package:flutter/material.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/theme/app_theme.dart';

class VidaADoidApp extends StatelessWidget {
  const VidaADoidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: Routes.homePage,
      routes: Routes.routes,
    );
  }
}
