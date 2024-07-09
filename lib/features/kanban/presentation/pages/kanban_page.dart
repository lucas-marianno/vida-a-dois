import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import '../widgets/kanban_column.dart';

class KanbanPage extends StatelessWidget {
  const KanbanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = FirestoreService.getMockKanbanColumns();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Kanban app concept'.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 4,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> columns = snapshot.data!.docs;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: columns.length,
              itemBuilder: (context, index) {
                // TODO: finish implementing this shit, then abstract it
                String columnId = columns[index].id;
                return StreamBuilder(
                  stream: FirestoreService.getMockColumnContent(columnId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return KanbanColumn(
                          columnId: columnId, taskList: snapshot.data!);
                    } else {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
