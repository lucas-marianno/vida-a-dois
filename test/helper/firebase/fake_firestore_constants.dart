import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:vida_a_dois/features/kanban/data/cloud_firestore/firestore_constants.dart';

class FakeFirestoreConstants extends FirestoreConstants {
  final FakeFirebaseFirestore instance;
  FakeFirestoreConstants(this.instance);

  final String kanbanCollection = 'mockKanbanCollection';

  CollectionReference get kanbanCollectionReference =>
      instance.collection(kanbanCollection);

  DocumentReference get boardsDocReference =>
      kanbanCollectionReference.doc('boards');

  CollectionReference get taskCollectionReference =>
      boardsDocReference.collection('tasks');
}
