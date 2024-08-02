import 'package:flutter/material.dart';

class UserSettings {
  String? uid;
  ThemeMode themeMode;
  String initials;
  Locale locale;

  UserSettings({
    this.uid,
    required this.themeMode,
    required this.locale,
    required this.initials,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      uid: json['uid'],
      themeMode: _fromString(json['theme']),
      initials: json['initials'],
      locale: Locale(json['locale']),
    );
  }

  Map<String, dynamic> get toJson {
    return {
      "uid": uid,
      "theme": themeMode,
      "initials": initials,
      "locale": locale.languageCode,
    };
  }

  static ThemeMode _fromString(String? themeMode) {
    if (themeMode == null) return ThemeMode.system;
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        throw UnimplementedError('themeMode $themeMode is not implemented');
    }
  }

  /// Returns a new [UserSettings] with the same values as the original.
  UserSettings copy() => UserSettings.fromJson(toJson);

  /// [equalsTo] makes a deep comparison between two [UserSettings] objects
  /// and returns `true` if all parameters match.
  bool equalsTo(UserSettings user) => '${user.toJson}' == '$toJson';
}
