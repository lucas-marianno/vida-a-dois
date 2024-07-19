import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/core/widgets/form/modal_form.dart';
import 'package:kanban/features/kanban/bloc/board/board_bloc.dart';
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
}

class TaskForm {
  static Future<Task?> readTask(
    Task task,
    BuildContext context, {
    bool initAsReadOnly = true,
  }) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return _EditTaskForm(
          task,
          formType: initAsReadOnly ? _TaskFormType.read : _TaskFormType.create,
        );
      },
    );
  }
}

class _EditTaskForm extends StatefulWidget {
  final Task? task;
  final _TaskFormType formType;
  const _EditTaskForm(this.task, {required this.formType});

  @override
  State<_EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<_EditTaskForm> {
  late TaskBloc taskBloc;
  late BoardBloc boardBloc;
  late Task newTask;
  late bool readOnly;
  late _TaskFormType formType;

  late String formTitle;

  void cancelForm() => Navigator.pop(context);

  void sendForm() {
    if (newTask.title == '') return;

    newTask.createdDate ??= Timestamp.now();
    Navigator.pop(context, newTask);
  }

  void deleteTaskAndClose() {
    Navigator.pop(context);

    if (widget.task == null) return;

    taskBloc.add(DeleteTaskEvent(widget.task!));
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
    super.initState();
    newTask = widget.task?.copy() ??
        Task(
          title: 'Nova tarefa',
          status: boardBloc.statusList[0].title,
        );
    formType = widget.formType;
    taskBloc = context.read<TaskBloc>();
    boardBloc = context.read<BoardBloc>();
  }

  @override
  Widget build(BuildContext context) {
    formTitle = formType.typeTitle;
    readOnly = formType == _TaskFormType.read;

    return ModalBottomForm(
      context: context,
      formTitle: FormTitle(
        title: formTitle,
        onIconPressed: deleteTaskAndClose,
        icon: formType != _TaskFormType.edit ? null : Icons.delete,
        color: Colors.red[800],
      ),
      body: [
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
            newTask.taskImportance = TaskImportance.fromString(newValue);
          },
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormDropDownMenuButton(
              label: 'Status da tarefa',
              flex: 1,
              enabled: !readOnly,
              initialValue: newTask.status,
              items: boardBloc.statusList.map((e) => e.title).toList(),
              onChanged: (newValue) {
                newTask.status = newValue ??= newTask.status;
              },
            ),
            const SizedBox(width: 6),
            FormDatePicker(
              label: 'Prazo da tarefa',
              flex: 1,
              enabled: !readOnly,
              initialDate: newTask.dueDate?.toDate(),
              onChanged: (newDate) {
                newTask.dueDate =
                    newDate == null ? null : Timestamp.fromDate(newDate);
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    )
                  : null,
              onPressed: formType == _TaskFormType.create
                  ? cancelForm
                  : toggleEditMode,
              child: Text(readOnly ? 'Editar tarefa' : '    Cancelar   '),
            ),
            FilledButton(
              onPressed: formType == _TaskFormType.read ? null : sendForm,
              child: const Text('  Concluído  '),
            ),
          ],
        )
      ],
    ).widget();
  }
}
