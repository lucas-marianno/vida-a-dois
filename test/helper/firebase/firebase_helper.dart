import 'package:vida_a_dois/features/kanban/data/cloud_firestore/firestore_constants.dart';

deleteAllTasksFromMockFirebaseCollection() async {
  final taskMockCollection = MockFirestoreConstants.taskCollectionReference;

  final docs = (await taskMockCollection.get()).docs;

  for (var doc in docs) {
    await taskMockCollection.doc(doc.id).delete();
  }
}
