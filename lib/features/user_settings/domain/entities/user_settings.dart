import 'package:flutter/material.dart';

class UserSettings {
  String? uid;
  ThemeMode theme;
  String initials;
  Locale locale;

  UserSettings({
    this.uid,
    required this.theme,
    required this.locale,
    required this.initials,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      uid: json['uid'],
      theme: json['theme'],
      initials: json['initials'],
      locale: Locale(json['locale']),
    );
  }

  Map<String, dynamic> get toJson {
    return {
      "uid": uid,
      "theme": theme,
      "initials": initials,
      "locale": locale.languageCode,
    };
  }

  /// Returns a new [UserSettings] with the same values as the original.
  UserSettings copy() => UserSettings.fromJson(toJson);

  /// [equalsTo] makes a deep comparison between two [UserSettings] objects
  /// and returns `true` if all parameters match.
  bool equalsTo(UserSettings user) => '${user.toJson}' == '$toJson';
}
