import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreReferences {
  FirestoreReferences(this.firestoreInstance);
  final FirebaseFirestore firestoreInstance;

  CollectionReference get kanbanCollectionRef;
  DocumentReference get boardsDocRef;
  CollectionReference get taskCollectionRef;
}

class FirestoreReferencesImpl extends FirestoreReferences {
  FirestoreReferencesImpl(super.firestoreInstance);

  @override
  CollectionReference get kanbanCollectionRef =>
      firestoreInstance.collection('mockKanbanCollection2');

  @override
  DocumentReference get boardsDocRef => kanbanCollectionRef.doc('boards');

  @override
  CollectionReference get taskCollectionRef => boardsDocRef.collection('tasks');
}
