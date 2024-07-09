import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/presentation/widgets/create_task_form.dart';

// import 'features/kanban/presentation/pages/kanban_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WidgetCreatorHelper();
    // return const KanbanPage();
  }
}

class WidgetCreatorHelper extends StatelessWidget {
  const WidgetCreatorHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text('widget creator helper'.toUpperCase()),
          centerTitle: true,
        ),
        body: const Center(child: CreateTaskForm()),
      ),
    );
  }
}
