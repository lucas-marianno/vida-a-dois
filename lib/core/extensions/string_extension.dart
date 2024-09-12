import 'package:flutter/material.dart';

extension StringExtension on String? {
  /// Returns a `ThemeMode` from a `string`.
  ///
  /// Throws `FlutterError` if `string` is different from `light`, `dark`
  /// or `system`.
  ///
  /// ```dart
  /// ThemeMode toThemeMode() {
  ///   switch (this?.toLowerCase()) {
  ///     case null || 'null' || '' || 'system':
  ///       return ThemeMode.system;
  ///     case 'light':
  ///       return ThemeMode.light;
  ///     case 'dark':
  ///       return ThemeMode.dark;
  ///     default:
  ///       throw FlutterError('"$this" is not a valid ThemeMode');
  ///   }
  /// }
  /// ```
  ThemeMode toThemeMode() {
    switch (this?.toLowerCase()) {
      case null || 'null' || '' || 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        throw FlutterError('"$this" is not a valid ThemeMode');
    }
  }
}
