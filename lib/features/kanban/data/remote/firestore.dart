import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/core/constants/firebase/firebase_constants.dart';

abstract class FirestoreService {
  static final instance = FirebaseFirestore.instance;

  static Stream getMockKanbanCollection() {
    return instance
        .collection(FireStoreConstants.mockKanbanCollection)
        .orderBy('columnName', descending: true)
        .snapshots();
  }
}
