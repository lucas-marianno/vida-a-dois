import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FireStoreConstants {
  static const String mockKanbanCollection = 'mockKanbanCollection2';
  static final CollectionReference mockCollectionReference =
      FirebaseFirestore.instance.collection(mockKanbanCollection);
}
