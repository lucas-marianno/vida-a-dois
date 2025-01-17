import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vida_a_dois/core/constants/form_type.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/core/util/dialogs/info_dialog.dart';
import 'package:vida_a_dois/core/widgets/form/modal_form.dart';

import 'package:vida_a_dois/features/kanban/domain/constants/enum/task_importance.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/extensions/task_importance_ui_extension.dart';

class TaskForm {
  final BuildContext context;
  TaskForm(this.context);

  Future<Task?> show(Task task, {bool isNewTask = false}) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return EditTaskForm(
          task,
          formType: isNewTask ? FormType.create : FormType.read,
          key: const Key('taskForm'),
        );
      },
    );
  }
}

class EditTaskForm extends StatefulWidget {
  final Task task;
  final FormType formType;
  const EditTaskForm(this.task, {super.key, required this.formType});

  @override
  State<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  late TaskBloc taskBloc;
  late BoardBloc boardBloc;
  late Task newTask;
  late bool readOnly;
  late FormType formType;

  late String formTitle;

  void cancelForm() => Navigator.pop(context);

  void sendForm() {
    if (newTask.title == '') return;
    if (newTask.createdDate == null) {
      newTask = newTask.copyWith(createdDate: DateTime.now());
    }
    Navigator.pop(context, newTask);
  }

  void deleteTaskAndClose() async {
    Navigator.pop(context);

    final l10n = L10n.of(context);

    final response = await InfoDialog.show(
      context,
      l10n.deleteTaskPromptDescription(widget.task.title),
      title: '${l10n.delete} ${l10n.task.toLowerCase()}?',
    );

    if (response != true) return;

    taskBloc.add(DeleteTask(widget.task));
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

    newTask = widget.task.copyWith();
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
            newTask = newTask.copyWith(title: newString);
          },
          mandatory: true,
        ),
        MyFormField(
          label: l10n.taskDescription,
          enabled: !readOnly,
          initialValue: newTask.description,
          multilineFormField: true,
          onChanged: (newString) {
            newTask = newTask.copyWith(description: newString);
          },
        ),
        //TODO: allow user to determine an assignee
        const ListTile(title: Text('assignee placeholder')),
        // FormDropDownMenuButton(
        //   label: l10n.taskAssignee,
        //   enabled: !readOnly,
        //   initialValue: newTask.assingneeUID.name,
        //   items: TaskAssignee.values.map((e) => e.name).toList(),
        //   onChanged: (newValue) {
        //     newTask.assingneeUID = TaskAssignee.fromString(newValue);
        //   },
        // ),
        FormDropDownMenuButton(
          label: l10n.taskImportance,
          enabled: !readOnly,
          initialValue: newTask.importance.localizeName(context),
          items: TaskImportance.values
              .map((e) => e.localizeName(context))
              .toList(),
          onChanged: (newValue) => newTask = newTask.copyWith(
            importance: TaskImportanceUI.fromLocalizedName(newValue, context),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<BoardBloc, BoardState>(
              builder: (context, state) {
                if (state is BoardLoadedState) {
                  return FormDropDownMenuButton(
                    label: l10n.taskStatus,
                    flex: 1,
                    enabled: !readOnly,
                    initialValue: newTask.status,
                    items: state.boards.map((e) => e.title).toList(),
                    onChanged: (newValue) {
                      newTask = newTask.copyWith(status: newValue);
                    },
                  );
                }
                return const Expanded(
                    child: Center(child: LinearProgressIndicator()));
              },
            ),
            const SizedBox(width: 6),
            FormDatePicker(
              label: l10n.taskDeadline,
              flex: 1,
              enabled: !readOnly,
              initialDate: newTask.deadline,
              onChanged: (newDate) {
                newTask = newTask.copyWith(dueDate: newDate);
              },
            ),
          ],
        ),
        //TODO: implement createdBy UI
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            'createdBy: ${widget.task.createdBy}',
            textAlign: TextAlign.end,
          ),
        ),
        //TODO: implement created date UI
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            'created date: ${widget.task.createdDate}',
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              key: const Key('editCancelButton'),
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
              key: const Key('doneButton'),
              onPressed: formType == FormType.read ? null : sendForm,
              child: Text(l10n.done),
            ),
          ],
        )
      ],
    ).widget();
  }
}
