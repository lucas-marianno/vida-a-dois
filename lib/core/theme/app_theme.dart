import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
          shadow: const Color.fromARGB(158, 158, 158, 158),
        ),
      );

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
