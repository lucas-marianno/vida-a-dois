import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/form_widgets/form_date_picker.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/form_widgets/form_drop_down_menu_button.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/form_widgets/form_title.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/form_widgets/form_field.dart';
import 'package:kanban/features/kanban/bloc/column/column_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

enum _TaskFormType {
  create,
  edit,
  read;

  String get typeTitle {
    switch (this) {
      case create:
        return 'Criando uma Tarefa';
      case edit:
        return 'Editando uma Tarefa';
      case read:
        return 'Lendo uma Tarefa';
    }
  }

  IconData? get icon {
    switch (this) {
      case create:
        return Icons.add;
      case edit:
        return Icons.check;
      case read:
        return null;
    }
  }
}

class TaskForm {
  static final Task _newTask = Task(title: 'Nova Tarefa');

  static Future<Task?> newTask(BuildContext context) async {
    return await _showModal(_newTask, context, _TaskFormType.create);
  }

  static Future<Task?> readTask(Task task, BuildContext context) async {
    return await _showModal(task, context, _TaskFormType.read);
  }

  static Future<Task?> _showModal(
    Task task,
    BuildContext context,
    _TaskFormType formType,
  ) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return _EditTaskForm(task, formType: formType);
      },
    );
  }
}

class _EditTaskForm extends StatefulWidget {
  final Task task;
  final _TaskFormType formType;
  const _EditTaskForm(this.task, {required this.formType});

  @override
  State<_EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<_EditTaskForm> {
  late Task newTask;
  late bool readOnly;
  late _TaskFormType formType;

  void sendForm() {
    if (newTask.title == '') return;

    newTask.createdDate ??= Timestamp.now();
    Navigator.pop(context, newTask);
  }

  void deleteTaskAndClose() {
    Navigator.pop(context);

    context.read<TaskBloc>().add(DeleteTaskEvent(widget.task));
  }

  void toggleEditMode() {
    setState(() {
      formType = formType == _TaskFormType.edit
          ? _TaskFormType.read
          : _TaskFormType.edit;
    });
  }

  @override
  void initState() {
    newTask = widget.task.copy();
    formType = widget.formType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    readOnly = formType == _TaskFormType.read;
    double padding = 15;
    double width = MediaQuery.of(context).size.width - padding * 2;

    String formTitle = formType.typeTitle;

    return Container(
      height: MediaQuery.of(context).viewInsets.bottom +
          MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: padding,
        right: padding,
        top: padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          FormTitle(
            title: formTitle,
            onIconPressed: deleteTaskAndClose,
            icon: formType != _TaskFormType.edit ? null : Icons.delete,
            color: Colors.red[800],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    readOnly ? ' ' : "* campos obrigatórios!",
                    textAlign: TextAlign.end,
                  ),
                ),
                MyFormField(
                  label: 'Tarefa',
                  enabled: !readOnly,
                  initialValue: newTask.title,
                  onChanged: (newString) {
                    newTask.title = newString!;
                  },
                  mandatory: true,
                ),
                MyFormField(
                  label: 'Descrição da tarefa',
                  enabled: !readOnly,
                  initialValue: newTask.description,
                  multilineFormField: true,
                  onChanged: (newString) {
                    newTask.description = newString;
                  },
                ),
                FormDropDownMenuButton(
                  label: 'Responsável pela tarefa',
                  enabled: !readOnly,
                  initialValue: newTask.assingnee.name,
                  items: TaskAssignee.values.map((e) => e.name).toList(),
                  onChanged: (newValue) {
                    newTask.assingnee = TaskAssignee.fromString(newValue);
                  },
                ),
                FormDropDownMenuButton(
                  label: 'Importância da tarefa',
                  enabled: !readOnly,
                  initialValue: newTask.taskImportance.name,
                  items: TaskImportance.values.map((e) => e.name).toList(),
                  onChanged: (newValue) {
                    newTask.taskImportance =
                        TaskImportance.fromString(newValue);
                  },
                ),
                Row(
                  children: [
                    FormDropDownMenuButton(
                      maxWidth: width / 2 - 3,
                      label: 'Status da tarefa',
                      enabled: !readOnly,
                      initialValue: newTask.status,
                      items:
                          ColumnsBloc.statusList.map((e) => e.title).toList(),
                      onChanged: (newValue) {
                        newTask.status = newValue!;
                      },
                    ),
                    const SizedBox(width: 6),
                    FormDatePicker(
                      label: 'Prazo da tarefa',
                      enabled: !readOnly,
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: readOnly
                          ? ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            )
                          : null,
                      onPressed: () {
                        if (formType == _TaskFormType.create) {
                          Navigator.pop(context);
                        } else {
                          toggleEditMode();
                        }
                      },
                      child:
                          Text(readOnly ? 'Editar Tarefa' : '    Cancelar   '),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed:
                          formType == _TaskFormType.read ? null : sendForm,
                      child: const Text('  Concluído  '),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
