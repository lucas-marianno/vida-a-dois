import 'package:flutter/material.dart';

class AppTheme {
  static bool darkmode = true;

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[200],
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

  static ThemeData get theme => darkmode ? dark : light;

  /// [userPreference] is not implemented yet!
  ///
  /// THROWS: UninplementedError()
  ///
  /// TODO: save user preference to firebase, retrieve it
  /// and return .light or dark accordingly
  static ThemeData userPreference() {
    throw UnimplementedError();
  }
}
