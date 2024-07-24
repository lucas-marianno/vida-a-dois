import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/constants/enum.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/alert_dialog.dart';
import 'package:kanban/core/widgets/form/modal_form.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

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
          formType: initAsReadOnly ? FormType.read : FormType.create,
        );
      },
    );
  }
}

class _EditTaskForm extends StatefulWidget {
  final Task? task;
  final FormType formType;
  const _EditTaskForm(this.task, {required this.formType});

  @override
  State<_EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<_EditTaskForm> {
  late TaskBloc taskBloc;
  late BoardBloc boardBloc;
  late Task newTask;
  late bool readOnly;
  late FormType formType;

  late String formTitle;

  void cancelForm() => Navigator.pop(context);

  void sendForm() {
    if (newTask.title == '') return;

    newTask.createdDate ??= Timestamp.now();
    Navigator.pop(context, newTask);
  }

  void deleteTaskAndClose() async {
    Navigator.pop(context);

    if (widget.task == null) return;

    final l10n = L10n.of(context);

    final response = await showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          context: context,
          title: '${l10n.delete} ${l10n.task.toLowerCase()}?',
          content: l10n.deleteTaskPromptDescription(widget.task!.title),
          onAccept: () => Navigator.pop(context, true),
        );
      },
    );

    if (response != true) return;

    taskBloc.add(DeleteTaskEvent(widget.task!));
  }

  void toggleEditMode() {
    setState(() {
      formType = formType == FormType.edit ? FormType.read : FormType.edit;
    });
  }

  String typeTitle(l10n) {
    switch (formType) {
      case FormType.create:
        return l10n.creatingATask;
      case FormType.edit:
        return l10n.editingATask;
      case FormType.read:
        return l10n.readingATask;
    }
  }

  @override
  void initState() {
    super.initState();
    newTask = widget.task?.copy() ??
        Task(
          title: L10n.of(context).newTask,
          status: boardBloc.statusList[0].title,
        );
    formType = widget.formType;
    taskBloc = context.read<TaskBloc>();
    boardBloc = context.read<BoardBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    formTitle = typeTitle(l10n);
    readOnly = formType == FormType.read;

    return ModalBottomForm(
      context: context,
      formTitle: FormTitle(
        title: formTitle,
        onIconPressed: deleteTaskAndClose,
        icon: formType != FormType.edit ? null : Icons.delete,
        color: Colors.red[800],
      ),
      body: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            readOnly ? ' ' : l10n.mandatoryFields,
            textAlign: TextAlign.end,
          ),
        ),
        MyFormField(
          label: l10n.task,
          enabled: !readOnly,
          initialValue: newTask.title,
          onChanged: (newString) {
            newTask.title = newString!;
          },
          mandatory: true,
        ),
        MyFormField(
          label: l10n.taskDescription,
          enabled: !readOnly,
          initialValue: newTask.description,
          multilineFormField: true,
          onChanged: (newString) {
            newTask.description = newString;
          },
        ),
        FormDropDownMenuButton(
          label: l10n.taskAssignee,
          enabled: !readOnly,
          initialValue: newTask.assingnee.name,
          items: TaskAssignee.values.map((e) => e.name).toList(),
          onChanged: (newValue) {
            newTask.assingnee = TaskAssignee.fromString(newValue);
          },
        ),
        FormDropDownMenuButton(
          label: l10n.taskImportance,
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
              label: l10n.taskStatus,
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
              label: l10n.taskDeadline,
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
              onPressed:
                  formType == FormType.create ? cancelForm : toggleEditMode,
              child: Text(readOnly ? l10n.edit : l10n.cancel),
            ),
            FilledButton(
              onPressed: formType == FormType.read ? null : sendForm,
              child: Text(l10n.done),
            ),
          ],
        )
      ],
    ).widget();
  }
}
