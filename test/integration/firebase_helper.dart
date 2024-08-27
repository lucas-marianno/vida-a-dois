import 'package:vida_a_dois/core/constants/firebase_constants.dart';

deleteAllTasksFromMockFirebaseCollection() async {
  final taskMockCollection = MockFirebaseConstants.taskCollectionReference;

  final docs = (await taskMockCollection.get()).docs;

  for (var doc in docs) {
    await taskMockCollection.doc(doc.id).delete();
  }
}
