import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

class CreateTaskForm extends StatelessWidget {
  const CreateTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              double width = MediaQuery.of(context).size.width;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 15,
                  right: 15,
                  top: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: const Text('Adicionar Tarefa'),
                      trailing: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          foregroundColor: WidgetStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        onPressed: () {},
                        child: const Icon(Icons.add),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: Task.atributes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: SizedBox(
                              width: width * 0.18,
                              child: Text(
                                "${Task.atributes[index]}: ",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            title: const TextField(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Text('create task'));
  }
}
