import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:vida_a_dois/features/kanban/data/cloud_firestore/firestore_constants.dart';

abstract class FakeFirestoreConstants extends FirestoreConstants {
  static const String mockKanbanCollection = 'mockKanbanCollection';
  static final CollectionReference mockCollectionReference =
      FakeFirebaseFirestore().collection(mockKanbanCollection);

  static final DocumentReference boardsDocReference =
      mockCollectionReference.doc('boards');

  static final CollectionReference taskCollectionReference =
      boardsDocReference.collection('tasks');
}
