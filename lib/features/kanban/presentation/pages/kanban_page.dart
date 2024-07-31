import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/i18n/bloc/locale_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/error_dialog.dart';
import 'package:kanban/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/board_form.dart';
import '../widgets/kanban/kanban_board.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  late final BoardBloc boardBloc;
  late final TaskBloc taskBloc;
  late final LocaleBloc localeBloc;
  ScrollController scrlCtrl = ScrollController();

  void createBoard(Board board) async {
    final newBoard = await BoardForm.readBoard(
      Board(title: L10n.of(context).newBoard, index: 500),
      context,
      initAsReadOnly: false,
    );

    if (newBoard == null) return;

    boardBloc.add(CreateBoardEvent(newBoard));
  }

  @override
  void initState() {
    super.initState();

    boardBloc = context.read<BoardBloc>();
    taskBloc = context.read<TaskBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<BoardBloc, BoardsState>(
        builder: (context, state) {
          if (state is BoardLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BoardLoadedState) {
            final boards = state.boards;

            taskBloc.add(LoadTasksEvent(boards));

            return ListView.builder(
              controller: scrlCtrl,
              scrollDirection: Axis.horizontal,
              itemCount: boards.length + 1,
              itemBuilder: (context, index) {
                if (index < boards.length) {
                  return KanbanBoard(
                    board: boards[index],
                    horizontalController: scrlCtrl,
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () => createBoard(boards.last),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  );
                }
              },
            );
          } else if (state is BoardErrorState) {
            return Center(
              child: ErrorDialog(
                state.error,
                onAccept: () => boardBloc.add(ReloadBoards()),
              ),
            );
          } else {
            throw UnimplementedError(
              '$state implementation wasn\'t found in $BoardsState!',
            );
          }
        },
      ),
    );
  }
}
