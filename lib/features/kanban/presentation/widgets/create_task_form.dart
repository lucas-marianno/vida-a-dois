import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanban/core/constants/enum/assignee.dart';
import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/core/widgets/form_widgets/form_date_picker.dart';
import 'package:kanban/core/widgets/form_widgets/form_drop_down_menu_button.dart';
import 'package:kanban/core/widgets/form_widgets/form_title.dart';
import 'package:kanban/core/widgets/form_widgets/form_field.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

class TaskFromModalBottomForm {
  static final Task _newTask = Task(title: 'Nova Tarefa');

  static Future<Task?> newTask(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return _EditTaskForm(_newTask, formTitle: 'Adicionar Tarefa');
      },
    );
  }

  static Future<Task?> editTask(Task task, BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return _EditTaskForm(task, formTitle: 'Editar Tarefa');
      },
    );
  }
}

class _EditTaskForm extends StatefulWidget {
  final Task task;
  final String formTitle;
  const _EditTaskForm(this.task, {required this.formTitle});

  @override
  State<_EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<_EditTaskForm> {
  late Task newTask;

  void sendForm() {
    if (newTask.title == '') return;

    newTask.createdDate ??= Timestamp.now();
    Navigator.pop(context, newTask);
  }

  @override
  void initState() {
    newTask = widget.task.copy();
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
            title: widget.formTitle,
            onIconPressed: sendForm,
            icon: Icons.add,
          ),
          const Divider(),
          Expanded(
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
                    newTask.title = newString!;
                  },
                  mandatory: true,
                ),
                MyFormField(
                  label: 'Descrição da tarefa',
                  initialValue: newTask.description,
                  multilineFormField: true,
                  onChanged: (newString) {
                    newTask.description = newString;
                  },
                ),
                FormDropDownMenuButton(
                  label: 'Responsável pela tarefa',
                  initialValue: newTask.assingnedTo.name,
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
                      initialValue: newTask.status.name,
                      items: TaskStatus.values.map((e) => e.name).toList(),
                      onChanged: (newValue) {
                        newTask.status = TaskStatus.fromString(newValue);
                      },
                    ),
                    const SizedBox(width: 6),
                    FormDatePicker(
                      label: 'Prazo da tarefa',
                      initialDate: newTask.dueDate?.toDate(),
                      maxWidth: width / 2 - 3,
                      onChanged: (newDate) {
                        newTask.dueDate = newDate == null
                            ? null
                            : Timestamp.fromDate(newDate);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
