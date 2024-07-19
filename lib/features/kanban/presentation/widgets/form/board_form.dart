import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/core/widgets/form/modal_form.dart';
import 'package:kanban/features/kanban/bloc/board/board_bloc.dart';

enum _BoardFormType {
  create,
  edit,
  read;

  String get typeTitle {
    switch (this) {
      case create:
        return 'Criando um novo quadro';
      case edit:
        return 'Editando um quadro';
      case read:
        return 'Lendo um quadro';
    }
  }
}

class BoardForm {
  static Future<BoardEntity?> readBoard(
    BoardEntity board,
    BuildContext context, {
    bool initAsReadOnly = true,
  }) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return _EditBoardForm(
          board,
          formType:
              initAsReadOnly ? _BoardFormType.read : _BoardFormType.create,
        );
      },
    );
  }
}

class _EditBoardForm extends StatefulWidget {
  final BoardEntity board;
  final _BoardFormType formType;
  const _EditBoardForm(this.board, {required this.formType});

  @override
  State<_EditBoardForm> createState() => _EditBoardFormState();
}

class _EditBoardFormState extends State<_EditBoardForm> {
  late BoardBloc boardBloc;
  late BoardEntity newBoard;
  late bool readOnly;
  late _BoardFormType formType;

  void cancelForm() => Navigator.pop(context);
  void sendForm() {
    if (newBoard.title == '') return;

    toggleEditMode();

    Navigator.pop(context, newBoard);
  }

  void deleteBoardAndClose() {
    Navigator.pop(context);

    boardBloc.add(DeleteBoardEvent(widget.board));
  }

  void toggleEditMode() {
    setState(() {
      formType = formType == _BoardFormType.edit
          ? _BoardFormType.read
          : _BoardFormType.edit;
    });
  }

  @override
  void initState() {
    super.initState();
    formType = widget.formType;
    boardBloc = context.read<BoardBloc>();
    newBoard = widget.board.copy()
      ..index = widget.board.index.clamp(
        0,
        boardBloc.statusList.length,
      );
  }

  @override
  Widget build(BuildContext context) {
    readOnly = formType == _BoardFormType.read;

    String formTitle = formType.typeTitle;

    return ModalBottomForm(
      context: context,
      formTitle: FormTitle(
        title: formTitle,
        onIconPressed: deleteBoardAndClose,
        icon: formType != _BoardFormType.edit ? null : Icons.delete,
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
          label: 'Nome do quadro',
          enabled: !readOnly,
          initialValue: newBoard.title,
          onChanged: (newString) {
            newBoard.title = newString!;
          },
          mandatory: true,
        ),
        () {
          final items = boardBloc.statusList.map((e) {
                return '${e.index} - Antes de "${e.title}"';
              }).toList() +
              ['${boardBloc.statusList.length} - Adicionar ao final'];
          return FormDropDownMenuButton(
            enabled: !readOnly,
            label: 'Posição',
            initialValue: items[newBoard.index],
            items: items,
            onChanged: (e) {
              newBoard.index =
                  int.tryParse(e?.substring(0, 1) ?? '') ?? newBoard.index;
            },
          );
        }(),
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
              onPressed: formType == _BoardFormType.create
                  ? cancelForm
                  : toggleEditMode,
              child: Text(readOnly ? 'Editar Quadro' : '    Cancelar   '),
            ),
            FilledButton(
              onPressed: formType == _BoardFormType.read ? null : sendForm,
              child: const Text('  Concluído  '),
            ),
          ],
        )
      ],
    ).widget();
  }
}
