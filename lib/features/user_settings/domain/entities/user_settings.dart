import 'package:flutter/material.dart';
import 'package:kanban/core/extentions/string_extension.dart';

class UserSettings {
  String? uid;
  String? userName;
  ThemeMode themeMode;
  String initials;
  Locale locale;

  UserSettings({
    required this.uid,
    required this.userName,
    required this.themeMode,
    required this.locale,
    required this.initials,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      uid: json['uid'],
      userName: json['userName'],
      themeMode: json['theme'].toString().toThemeMode(),
      initials: json['initials'],
      locale: Locale(json['locale']),
    );
  }

  Map<String, dynamic> get toJson {
    return {
      "uid": uid,
      "userName": userName,
      "theme": themeMode.name,
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
