import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/data/remote/firestore.dart';
import '../../../../core/constants/enum/task_status.dart';
import '../../presentation/widgets/kanban_column.dart';
import '../../domain/repository/task_repository.dart';

class KanbanPage extends StatelessWidget {
  const KanbanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Kanban app concept'.toUpperCase(),
            style: const TextStyle(
              letterSpacing: 4,
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirestoreService.getMockKanbanCollection(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List columns = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: columns.length,
                itemBuilder: (context, index) {
                  // TODO: finish implementing this shit, then abstract it
                  return KanbanColumn(
                    columnName: columns[index]['columnName'],
                    taskList: [],
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
