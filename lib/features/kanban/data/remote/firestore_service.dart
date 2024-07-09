import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

abstract class FirestoreService {
  static final _firestoreMockCollection = FirebaseFirestore.instance
      .collection(FireStoreConstants.mockKanbanCollection);

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMockKanbanColumns() {
    return _firestoreMockCollection.orderBy('position').snapshots();
  }

  static Stream<List<Task>> getMockColumnContent(String columnId) {
    return _columnReference(columnId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => Task(
                title: doc['title'],
                status: TaskStatus.fromString(columnId),
              ),
            )
            .toList());
  }

  static void addTaskToColumn(Task task, String columnId) async {
    // final String title;
    // final String? description;
    // final Person? assingnedTo;
    // final TaskImportance taskImportance;
    // final TaskStatus status;
    // final Timestamp? dueDate;
    // final Timestamp? createdDate;
    await _columnReference(columnId).add({
      'title': task.title,
      'description': task.description,
      'assingnedTo': task.assingnedTo,
      'taskImportance': task.taskImportance.name,
      'taskStatus': TaskStatus.fromString(columnId).name,
      'dueDate': task.dueDate,
      'createdDate': task.createdDate,
    });
  }

  static CollectionReference _columnReference(String columnId) =>
      _firestoreMockCollection.doc(columnId).collection('tasks');
}
