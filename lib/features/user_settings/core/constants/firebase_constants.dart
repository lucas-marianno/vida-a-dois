import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseConstants {
  static const String _userSettings = "userSettings";

  static final CollectionReference userSettingsCollection =
      FirebaseFirestore.instance.collection(_userSettings);
}
