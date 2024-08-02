import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[200],
        dialogBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: const Color.fromARGB(255, 54, 97, 142),
          onSecondary: Colors.white,
          surface: Colors.white,
          surfaceContainerLow: Colors.grey[100],
          shadow: const Color.fromARGB(158, 158, 158, 158),
        ),
      );
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[950],
        dialogBackgroundColor: Colors.grey[850],
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: const Color.fromARGB(255, 54, 97, 142),
          onSecondary: Colors.white,
          surface: Colors.grey[850]!,
          surfaceContainerLow: Colors.grey[900],
          shadow: const Color.fromARGB(255, 0, 0, 0),
        ),
      );
}
