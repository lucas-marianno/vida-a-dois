import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreConstants {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static const String mockKanbanCollection = 'mockKanbanCollection2';

  static final CollectionReference mockCollectionReference =
      _instance.collection(mockKanbanCollection);

  static final DocumentReference boardsDocReference =
      mockCollectionReference.doc('boards');

  static final CollectionReference taskCollectionReference =
      boardsDocReference.collection('tasks');
}

abstract class MockFirestoreConstants extends FirestoreConstants {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static const String mockKanbanCollection = 'mockKanbanCollection3';

  static final CollectionReference mockCollectionReference =
      _instance.collection(mockKanbanCollection);

  static final DocumentReference boardsDocReference =
      mockCollectionReference.doc('boards');

  static final CollectionReference taskCollectionReference =
      boardsDocReference.collection('tasks');
}
