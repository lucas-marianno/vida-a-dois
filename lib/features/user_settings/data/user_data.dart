import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/user_settings/core/constants/firebase_constants.dart';
import 'package:kanban/features/user_settings/domain/entities/user_settings.dart';

class UserSettingsDataSource {
  static final _firebase = FirebaseConstants.userSettingsCollection;

  static Future<bool> hasSettings(String uid) async {
    final a = await _firebase.doc(uid).get();
    return a.data() != null;
  }

  static Future<void> create(UserSettings userSettings) async {
    return await _firebase.doc(userSettings.uid).set(userSettings.toJson);
  }

  static Stream<UserSettings> read(String uid) {
    return _firebase.doc(uid).snapshots().map((snapshot) {
      return UserSettings.fromJson(snapshot.data() as Map<String, dynamic>)
        ..uid = uid;
    });
  }

  static Future<void> update(UserSettings userSettings) async {
    return await _firebase.doc(userSettings.uid).set(
          userSettings.toJson,
          SetOptions(merge: true),
        );
  }
}
