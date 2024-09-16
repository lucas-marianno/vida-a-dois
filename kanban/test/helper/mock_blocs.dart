import 'package:bloc_test/bloc_test.dart';
import 'package:kanban/src/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/src/presentation/bloc/task/task_bloc.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class MockBoardBloc extends MockBloc<BoardEvent, BoardState>
    implements BoardBloc {}
