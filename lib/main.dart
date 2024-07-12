import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/theme/app_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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
