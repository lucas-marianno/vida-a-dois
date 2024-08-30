import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirestoreReferences {
  final FirebaseFirestore firestoreInstance;
  final FirebaseAuth firebaseAuth;
  FirestoreReferences({
    required this.firestoreInstance,
    required this.firebaseAuth,
  });

  CollectionReference get kanbanCollectionRef;
  DocumentReference get boardsDocRef;
  CollectionReference get taskCollectionRef;
  CollectionReference get userSettingsCollectionRef;
}

class FirestoreReferencesImpl extends FirestoreReferences {
  FirestoreReferencesImpl({
    required super.firestoreInstance,
    required super.firebaseAuth,
  });

  @override
  CollectionReference get kanbanCollectionRef =>
      firestoreInstance.collection('mockKanbanCollection2');

  @override
  DocumentReference get boardsDocRef => kanbanCollectionRef.doc('boards');

  @override
  CollectionReference get taskCollectionRef => boardsDocRef.collection('tasks');

  @override
  CollectionReference get userSettingsCollectionRef =>
      firestoreInstance.collection("userSettings");
}
