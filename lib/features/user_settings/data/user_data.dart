import 'package:kanban/features/user_settings/core/constants/firebase_constants.dart';
import 'package:kanban/features/user_settings/domain/entities/user_settings.dart';

class UserSettingsDataSource {
  static final _firebase = FirebaseConstants.userSettingsCollection;

  static Future<void> create(UserSettings userSettings) async {
    await _firebase.doc(userSettings.uid).set(userSettings.toJson);
  }

  static Stream<UserSettings> read(String uid) {
    return _firebase.doc(uid).snapshots().map((snapshot) =>
        UserSettings.fromJson(snapshot.data() as Map<String, dynamic>)
          ..uid = uid);
  }
}
