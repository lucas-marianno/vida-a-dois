import 'dart:math';

import 'package:flutter/material.dart';

enum TaskStatus {
  todo,
  inProgress,
  done;

  String get name {
    switch (this) {
      case TaskStatus.todo:
        return 'To do';
      case TaskStatus.inProgress:
        return 'In progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}

Map<TaskStatus, List<Task>> taskList = {
  TaskStatus.todo: todo,
  TaskStatus.inProgress: inProgress,
  TaskStatus.done: done,
};

List<Task> todo = [
  Task(title: 'todo 1', status: TaskStatus.todo),
  Task(title: 'todo 2', status: TaskStatus.todo),
  Task(title: 'todo 3', status: TaskStatus.todo),
];
List<Task> inProgress = [
  Task(title: 'in progress 1', status: TaskStatus.inProgress),
  Task(title: 'in progress 2', status: TaskStatus.inProgress),
  Task(title: 'in progress 3', status: TaskStatus.inProgress),
  Task(title: 'in progress 4', status: TaskStatus.inProgress),
  Task(title: 'in progress 5', status: TaskStatus.inProgress),
  Task(title: 'in progress 6', status: TaskStatus.inProgress),
];
List<Task> done = [
  // Task(title: 'done 1'),
];

void removeTaskFromColumn(Task task) {
  taskList[task.status]!.remove(task);
  // TODO: call setStatus after this.
}

class Task {
  final String title;
  TaskStatus status;
  Task({required this.title, required this.status});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          TaskStatus taskStatus = taskList.entries.toList()[index].key;
          return KanbanColumn(
            columnName: taskStatus.name,
            taskList: taskList[taskStatus],
          );
        },
      ),
    );
  }
}

class KanbanColumn extends StatelessWidget {
  final String columnName;
  final List<Task>? taskList;
  const KanbanColumn({
    required this.columnName,
    required this.taskList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double widthMultiplier = 0.6;
    double width = MediaQuery.of(context).size.width * widthMultiplier;

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Center(child: Text(columnName)),
          DragTarget(
            onAcceptWithDetails: (data) {
              if (data.data is Task) {
                print(data.offset);
                taskList?.add(data.data as Task);
              }
            },
            builder: (context, candidateData, rejectedData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: max(taskList?.length ?? 0, 1),
                padding: const EdgeInsets.symmetric(vertical: 1),
                itemBuilder: (context, index) {
                  if (taskList == null || taskList!.isEmpty) {
                    return const Center(child: Text('No tasks here!'));
                  }

                  return KanbanTile(
                    task: taskList![index],
                    tileHeight: width / 3,
                    tileWidth: width,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class KanbanTile extends StatelessWidget {
  final Task task;
  final double tileHeight;
  final double tileWidth;
  const KanbanTile({
    required this.task,
    required this.tileHeight,
    required this.tileWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile = createTile(task.title);
    return LongPressDraggable(
      data: task,
      onDragEnd: (details) {
        if (details.wasAccepted) {
          removeTaskFromColumn(task);
        }
      },
      feedback: tile,
      childWhenDragging: Text(
        task.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      child: tile,
    );
  }

  Widget createTile(String tarefa) => Material(
        color: Colors.transparent,
        child: Container(
          height: tileHeight,
          width: tileWidth,
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // tarefa proposta
              Text(
                tarefa,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const ListTile(
                // Permitir que o usuário escolha um icone de uma lista
                leading: Icon(Icons.tapas_outlined),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Exibir a foto da pessoa que foi atribuida a tarefa
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    // Permitir atribuir um nível de importancia para a tarefa
                    Icon(Icons.label_important),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
