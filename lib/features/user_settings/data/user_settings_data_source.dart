import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanban/src/data/cloud_firestore/firestore_references.dart';
import 'package:vida_a_dois/features/user_settings/domain/entities/user_settings.dart';

abstract class UserSettingsDataSource {
  final FirestoreReferences firestoreReferences;

  UserSettingsDataSource({required this.firestoreReferences});

  User? get currentUser;
  Future<UserSettings?> getSettings(String uid);
  Future<void> create(UserSettings userSettings);
  Stream<UserSettings> read(String uid);
  Future<void> update(UserSettings userSettings);
}

class UserSettingsDataSourceImpl extends UserSettingsDataSource {
  final CollectionReference _firebase;

  UserSettingsDataSourceImpl({required super.firestoreReferences})
      : _firebase = firestoreReferences.userSettingsCollectionRef;

  @override
  User? get currentUser => super.firestoreReferences.firebaseAuth.currentUser;

  @override
  Future<UserSettings?> getSettings(String uid) async {
    final a = await _firebase.doc(uid).get();
    if (a.data() == null) return null;

    return UserSettings.fromJson(a.data() as Map<String, dynamic>);
  }

  @override
  Future<void> create(UserSettings userSettings) async {
    return await _firebase.doc(userSettings.uid).set(userSettings.toJson);
  }

  @override
  Stream<UserSettings> read(String uid) {
    return _firebase.doc(uid).snapshots().map((snapshot) {
      return UserSettings.fromJson(snapshot.data() as Map<String, dynamic>)
        ..uid = uid;
    });
  }

  @override
  Future<void> update(UserSettings userSettings) async {
    return await _firebase.doc(userSettings.uid).set(
          userSettings.toJson,
          SetOptions(merge: true),
        );
  }
}
