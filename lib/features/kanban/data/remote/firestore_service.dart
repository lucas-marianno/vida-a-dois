import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/core/constants/firebase/firebase_constants.dart';

abstract class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMockKanbanColumns() {
    return _firestore
        .collection(FireStoreConstants.mockKanbanCollection)
        .orderBy('position')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMockColumnContent(
      String columnId) {
    return _firestore
        .collection(FireStoreConstants.mockKanbanCollection)
        .doc(columnId)
        .collection('tasks')
        .snapshots();
  }
}
