import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanban/core/constants/enum/assignee.dart';
import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/core/widgets/form_widgets/form_date_picker.dart';
import 'package:kanban/core/widgets/form_widgets/form_drop_down_menu_button.dart';
import 'package:kanban/core/widgets/form_widgets/form_title.dart';
import 'package:kanban/core/widgets/form_widgets/form_field.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

class CreateTaskFromModalBottomForm {
  static Future<Task?> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return const _CreateTaskForm();
      },
    );
  }
}

class _CreateTaskForm extends StatefulWidget {
  const _CreateTaskForm();

  @override
  State<_CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<_CreateTaskForm> {
  late Task newTask;

  void sendForm() {
    if (newTask.title == '') return;

    newTask.createdDate = Timestamp.now();
    Navigator.pop(context, newTask);
  }

  @override
  void initState() {
    newTask = Task(
      title: 'Nova Tarefa',
      status: TaskStatus.todo,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double padding = 15;
    double width = MediaQuery.of(context).size.width - padding * 2;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: padding,
        right: padding,
        top: padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormTitle(
            title: 'Adicionar Tarefa (Detalhada)',
            onIconPressed: sendForm,
            icon: Icons.add,
          ),
          const Divider(),
          Expanded(
            child: Form(
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "* campos obrigatórios!",
                      textAlign: TextAlign.end,
                    ),
                  ),
                  MyFormField(
                    label: 'Tarefa',
                    initialValue: newTask.title,
                    onChanged: (newString) {
                      newTask.title = newString;
                    },
                    mandatory: true,
                  ),
                  MyFormField(
                    label: 'Descrição da tarefa',
                    multilineFormField: true,
                    onChanged: (newString) {
                      newTask.description = newString;
                    },
                  ),
                  FormDropDownMenuButton(
                    label: 'Responsável pela tarefa',
                    items: Assignee.values.map((e) => e.name).toList(),
                    onChanged: (newValue) {
                      newTask.assingnedTo = Assignee.fromString(newValue);
                    },
                  ),
                  Row(
                    children: [
                      FormDropDownMenuButton(
                        maxWidth: width / 2 - 3,
                        label: 'Status da tarefa',
                        items: TaskStatus.values.map((e) => e.name).toList(),
                        onChanged: (newValue) {
                          newTask.status = TaskStatus.fromString(newValue);
                        },
                      ),
                      const SizedBox(width: 6),
                      FormDatePicker(
                        label: 'Prazo da tarefa',
                        maxWidth: width / 2 - 3,
                        onChanged: (newDate) {
                          newTask.dueDate = Timestamp.fromDate(newDate);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
