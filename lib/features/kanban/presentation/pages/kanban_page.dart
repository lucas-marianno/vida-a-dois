import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import '../widgets/kanban_column.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  ScrollController scrlCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    final stream = FirestoreService.getMockKanbanStatusColumns();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: Text(
          'Kanban app concept'.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> columns = snapshot.data!.docs;
              return ListView.builder(
                controller: scrlCtrl,
                scrollDirection: Axis.horizontal,
                itemCount: columns.length,
                itemBuilder: (context, index) {
                  // TODO: finish implementing this shit, then abstract it
                  TaskStatus columnId =
                      TaskStatus.fromString(columns[index].id);
                  return StreamBuilder(
                    stream:
                        FirestoreService.getMockStatusColumnContent(columnId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return KanbanColumn(
                          columnId: columnId,
                          taskList: snapshot.data!,
                          horizontalParentScrollController: scrlCtrl,
                        );
                      } else {
                        return KanbanColumn.loading(context);
                      }
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: LinearProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
