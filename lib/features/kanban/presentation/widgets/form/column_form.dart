import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/form_widgets/form_drop_down_menu_button.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/form_widgets/form_title.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/form_widgets/form_field.dart';
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
  static final ColumnEntity _newColumn = ColumnEntity(
    title: 'Nova Coluna',
    index: ColumnsBloc.statusList.length,
  );

  static Future<ColumnEntity?> newColumn(BuildContext context) async {
    return await _showModal(_newColumn, context, _ColumnFormType.create);
  }

  static Future<ColumnEntity?> readColumn(
    ColumnEntity column,
    BuildContext context,
  ) async {
    return await _showModal(column, context, _ColumnFormType.read);
  }

  static Future<ColumnEntity?> _showModal(
    ColumnEntity column,
    BuildContext context,
    _ColumnFormType formType,
  ) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) {
              return ColumnsBloc()..add(ColumnsInitialEvent(context));
            }),
          ],
          child: _EditColumnForm(column, formType: formType),
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

  void sendForm() {
    if (newColumn.title == '') return;

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
    newColumn = widget.column.copy();
    formType = widget.formType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    columnsBloc = context.read<ColumnsBloc>();
    readOnly = formType == _ColumnFormType.read;
    double padding = 15;

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
            onIconPressed: deleteColumnAndClose,
            icon: formType != _ColumnFormType.edit ? null : Icons.delete,
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
                  label: 'Nome da coluna',
                  enabled: !readOnly,
                  initialValue: newColumn.title,
                  onChanged: (newString) {
                    newColumn.title = newString!;
                  },
                  mandatory: true,
                ),
                () {
                  final items = ColumnsBloc.statusList.map((e) {
                        return '${e.index} - Antes de "${e.title}"';
                      }).toList() +
                      ['${ColumnsBloc.statusList.length} - Adicionar ao final'];
                  return FormDropDownMenuButton(
                    enabled: !readOnly,
                    label: 'Posição',
                    initialValue: items[newColumn.index],
                    items: items,
                    onChanged: (e) {
                      newColumn.index =
                          int.tryParse(e?.substring(0, 1) ?? '') ??
                              newColumn.index;
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            )
                          : null,
                      onPressed: () {
                        if (formType == _ColumnFormType.create) {
                          Navigator.pop(context);
                        } else {
                          toggleEditMode();
                        }
                      },
                      child:
                          Text(readOnly ? 'Editar Coluna' : '    Cancelar   '),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed:
                          formType == _ColumnFormType.read ? null : sendForm,
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
