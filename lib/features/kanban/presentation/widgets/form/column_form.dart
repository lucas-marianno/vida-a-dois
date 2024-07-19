import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/core/widgets/form/modal_form.dart';
import 'package:kanban/features/kanban/bloc/column/column_bloc.dart';

enum _ColumnFormType {
  create,
  edit,
  read;

  String get typeTitle {
    switch (this) {
      case create:
        return 'Criando uma nova coluna';
      case edit:
        return 'Editando uma coluna';
      case read:
        return 'Lendo uma coluna';
    }
  }
}

class ColumnForm {
  static Future<ColumnEntity?> readColumn(
    ColumnEntity column,
    BuildContext context, {
    bool initAsReadOnly = true,
  }) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return _EditColumnForm(
          column,
          formType:
              initAsReadOnly ? _ColumnFormType.read : _ColumnFormType.create,
        );
      },
    );
  }
}

class _EditColumnForm extends StatefulWidget {
  final ColumnEntity column;
  final _ColumnFormType formType;
  const _EditColumnForm(this.column, {required this.formType});

  @override
  State<_EditColumnForm> createState() => _EditColumnFormState();
}

class _EditColumnFormState extends State<_EditColumnForm> {
  late ColumnsBloc columnsBloc;
  late ColumnEntity newColumn;
  late bool readOnly;
  late _ColumnFormType formType;

  void cancelForm() => Navigator.pop(context);
  void sendForm() {
    if (newColumn.title == '') return;

    toggleEditMode();

    Navigator.pop(context, newColumn);
  }

  void deleteColumnAndClose() {
    Navigator.pop(context);

    columnsBloc.add(DeleteColumnEvent(widget.column));
  }

  void toggleEditMode() {
    setState(() {
      formType = formType == _ColumnFormType.edit
          ? _ColumnFormType.read
          : _ColumnFormType.edit;
    });
  }

  @override
  void initState() {
    super.initState();
    formType = widget.formType;
    columnsBloc = context.read<ColumnsBloc>();
    newColumn = widget.column.copy()
      ..index = widget.column.index.clamp(
        0,
        columnsBloc.statusList.length,
      );
  }

  @override
  Widget build(BuildContext context) {
    readOnly = formType == _ColumnFormType.read;

    String formTitle = formType.typeTitle;

    return ModalBottomForm(
      context: context,
      formTitle: FormTitle(
        title: formTitle,
        onIconPressed: deleteColumnAndClose,
        icon: formType != _ColumnFormType.edit ? null : Icons.delete,
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
          label: 'Nome da coluna',
          enabled: !readOnly,
          initialValue: newColumn.title,
          onChanged: (newString) {
            newColumn.title = newString!;
          },
          mandatory: true,
        ),
        () {
          final items = columnsBloc.statusList.map((e) {
                return '${e.index} - Antes de "${e.title}"';
              }).toList() +
              ['${columnsBloc.statusList.length} - Adicionar ao final'];
          return FormDropDownMenuButton(
            enabled: !readOnly,
            label: 'Posição',
            initialValue: items[newColumn.index],
            items: items,
            onChanged: (e) {
              newColumn.index =
                  int.tryParse(e?.substring(0, 1) ?? '') ?? newColumn.index;
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
              onPressed: formType == _ColumnFormType.create
                  ? cancelForm
                  : toggleEditMode,
              child: Text(readOnly ? 'Editar Coluna' : '    Cancelar   '),
            ),
            FilledButton(
              onPressed: formType == _ColumnFormType.read ? null : sendForm,
              child: const Text('  Concluído  '),
            ),
          ],
        )
      ],
    ).widget();
  }
}
