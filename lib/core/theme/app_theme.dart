import 'package:flutter/material.dart';

class AppTheme {
  static bool darkmode = true;

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          brightness: Brightness.light,
          primary: const Color.fromARGB(255, 54, 97, 142),
          onPrimary: Colors.white,
          secondary: const Color.fromARGB(255, 104, 147, 192),
          surface: Colors.grey[100]!,
          surfaceContainerLow: const Color.fromARGB(255, 240, 240, 240),
          shadow: const Color.fromARGB(158, 158, 158, 158),
        ),
      );
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          brightness: Brightness.dark,
          primary: const Color.fromARGB(255, 54, 97, 142),
          onPrimary: Colors.white,
          secondary: const Color.fromARGB(255, 104, 147, 192),
          surface: Colors.grey[900]!,
          surfaceContainerLow: const Color.fromARGB(255, 28, 28, 28),
          shadow: const Color.fromARGB(99, 0, 0, 0),
        ),
      );
  // ColorScheme.fromSeed(
  //   seedColor: Colors.blue,
  //   brightness: Brightness.dark,
  //   shadow: Color.fromARGB(158, 20, 20, 20),
  // ),

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
