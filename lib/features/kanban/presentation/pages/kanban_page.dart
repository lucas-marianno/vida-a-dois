import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/core/util/dialogs/error_dialog.dart';
import 'package:vida_a_dois/core/util/dialogs/info_dialog.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/exceptions/kanban_exception.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/form/board_form.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/form/task_form.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_board.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  late final BoardBloc boardBloc;
  late final TaskBloc taskBloc;
  ScrollController scrlCtrl = ScrollController();

  void createBoard() async {
    final newBoard = await BoardForm.readBoard(
      Board(title: L10n.of(context).newBoard, index: 0),
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
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: MultiBlocListener(
        listeners: [
          BlocListener<BoardBloc, BoardState>(
            listener: (context, state) async {
              if (state is BoardErrorState) {
                boardBloc.add(ReloadBoards());
                if (state.error is NameNotUniqueException) {
                  await InfoDialog.show(
                    context,
                    L10n.of(context).boardUniqueNameException,
                    title: L10n.of(context).youCannotDoThat,
                  );
                } else {
                  await ErrorDialog.show(
                    context,
                    state.error,
                  );
                }
              }
            },
          ),
          BlocListener<TaskBloc, TaskState>(
            listener: (context, state) async {
              if (state is ReadingTask) {
                final newTask = await TaskForm(context)
                    .show(state.task, isNewTask: state.isNewTask);

                if (newTask == null) return;
                if (!state.isNewTask && newTask == state.task) return;

                taskBloc.add(UpdateTask(newTask, isNewTask: state.isNewTask));
              }
            },
          ),
        ],
        child: BlocBuilder<BoardBloc, BoardState>(
          builder: (context, state) {
            if (state is BoardLoadingState) {
              return const LinearProgressIndicator();
            } else if (state is BoardLoadedState) {
              final boards = state.boards;

              if (state.boards.isEmpty) {
                return Center(
                  child: InfoDialog(
                    l10n.createYourFirstBoard,
                    title: l10n.noBoardsYet,
                    onAccept: createBoard,
                  ),
                );
              }

              taskBloc.add(LoadTasks(boards));

              return ListView.builder(
                controller: scrlCtrl,
                scrollDirection: Axis.horizontal,
                itemCount: boards.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox(width: 10);
                  } else if (index < boards.length + 1) {
                    return KanbanBoard(
                      board: boards[index - 1],
                      horizontalController: scrlCtrl,
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 20),
                        child: ElevatedButton(
                          onPressed: createBoard,
                          child: const Icon(Icons.add),
                        ),
                      ),
                    );
                  }
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
