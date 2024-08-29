import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreConstants {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static const String kanbanCollection = 'mockKanbanCollection2';

  static final CollectionReference kanbanCollectionReference =
      _instance.collection(kanbanCollection);

  static final DocumentReference boardsDocReference =
      kanbanCollectionReference.doc('boards');

  static final CollectionReference taskCollectionReference =
      boardsDocReference.collection('tasks');
}

abstract class MockFirestoreConstants extends FirestoreConstants {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static const String kanbanCollection = 'mockKanbanCollection';

  static final CollectionReference kanbanCollectionReference =
      _instance.collection(kanbanCollection);

  static final DocumentReference boardsDocReference =
      kanbanCollectionReference.doc('boards');

  static final CollectionReference taskCollectionReference =
      boardsDocReference.collection('tasks');
}
