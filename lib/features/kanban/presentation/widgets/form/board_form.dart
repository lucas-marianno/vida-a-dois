import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vida_a_dois/core/constants/form_type.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/core/widgets/form/modal_form.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/board/board_bloc.dart';

class BoardForm {
  static Future<Board?> readBoard(
    Board board,
    BuildContext context, {
    bool initAsReadOnly = true,
  }) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return EditBoardForm(
          board,
          formType: initAsReadOnly ? FormType.read : FormType.create,
          key: const Key('boardForm'),
        );
      },
    );
  }
}

class EditBoardForm extends StatefulWidget {
  final Board board;
  final FormType formType;
  const EditBoardForm(this.board, {super.key, required this.formType});

  @override
  State<EditBoardForm> createState() => _EditBoardFormState();
}

class _EditBoardFormState extends State<EditBoardForm> {
  late BoardBloc boardBloc;
  late Board newBoard;
  late bool readOnly;
  late FormType formType;

  void cancelForm() => Navigator.pop(context);
  void sendForm() {
    if (newBoard.title == '') return;

    setState(() => formType = FormType.read);

    Navigator.pop(context, newBoard);
  }

  void deleteBoardAndClose() {
    Navigator.pop(context);

    boardBloc.add(DeleteBoardEvent(widget.board));
  }

  String typeTitle(l10n) {
    switch (formType) {
      case FormType.create:
        return l10n.creatingABoard;
      case FormType.edit:
        return l10n.editingABoard;
      case FormType.read:
        return l10n.readingABoard;
    }
  }

  void toggleEditMode() {
    setState(() {
      formType = formType == FormType.edit ? FormType.read : FormType.edit;
    });
  }

  @override
  void initState() {
    super.initState();
    formType = widget.formType;
    boardBloc = context.read<BoardBloc>();

    newBoard = widget.board.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    readOnly = formType == FormType.read;
    final l10n = L10n.of(context);
    String formTitle = typeTitle(l10n);

    return ModalBottomForm(
      context: context,
      formTitle: FormTitle(
        title: formTitle,
        onIconPressed: deleteBoardAndClose,
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
          label: l10n.boardName,
          enabled: !readOnly,
          initialValue: newBoard.title,
          onChanged: (newString) {
            newBoard = newBoard.copyWith(title: newString);
          },
          mandatory: true,
        ),
        BlocBuilder<BoardBloc, BoardState>(
          builder: (context, state) {
            if (state is BoardLoadedState) {
              final items = state.boards
                      .map((e) => '${e.index} - ${l10n.before} "${e.title}"')
                      .toList() +
                  ['${state.boards.length} - ${l10n.addToEnd}'];

              newBoard = newBoard.copyWith(
                  index: newBoard.index.clamp(0, items.length - 1));

              return FormDropDownMenuButton(
                enabled: !readOnly,
                label: l10n.position,
                initialValue: formType == FormType.create
                    ? items.last
                    : items[newBoard.index],
                items: items,
                onChanged: (e) {
                  newBoard = newBoard.copyWith(
                    index: int.tryParse(e?.substring(0, 1) ?? '') ??
                        newBoard.index,
                  );
                },
              );
            }
            return const Center(child: LinearProgressIndicator());
          },
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
              key: const Key('boardFormDoneButton'),
              onPressed: formType == FormType.read ? null : sendForm,
              child: Text(l10n.done),
            ),
          ],
        )
      ],
    ).widget();
  }
}
