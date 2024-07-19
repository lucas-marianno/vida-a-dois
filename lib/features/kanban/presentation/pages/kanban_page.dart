import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import '../widgets/kanban/kanban_board.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  late final BoardBloc boardBloc;
  late final TaskBloc taskBloc;
  ScrollController scrlCtrl = ScrollController();

  @override
  void initState() {
    super.initState();

    boardBloc = context.read<BoardBloc>()..add(BoardInitialEvent(context));
    taskBloc = context.read<TaskBloc>()..add(TaskInitialEvent(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: Text(
          'Kanban app concept'.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 4,
          ),
        ),
      ),
      body: Padding(
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
                      board: state.boards[index],
                      horizontalParentScrollController: scrlCtrl,
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          child: const Icon(Icons.add),
                          onPressed: () => boardBloc.add(CreateBoardEvent()),
                        ),
                      ),
                    );
                  }
                },
              );
            } else if (state is BoardErrorState) {
              return Center(
                child: Text("An error has ocurred \n"
                    "\n"
                    "${state.error.runtimeType}\n"
                    "\n"
                    "${state.errorMessage}"),
              );
            } else {
              throw UnimplementedError(
                  '$state implementation wasn\'t found in $BoardsState!');
            }
          },
        ),
      ),
    );
  }
}
