import 'package:get_it/get_it.dart';
import 'package:kanban/core/constants/firebase_constants.dart';
import 'package:kanban/features/kanban/data/data_sources/board_data_source.dart';
import 'package:kanban/features/kanban/data/data_sources/task_data_source.dart';
import 'package:kanban/features/kanban/data/repositories/board_repository_impl.dart';
import 'package:kanban/features/kanban/data/repositories/task_repository_impl.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';
import 'package:kanban/features/kanban/domain/usecases/board/create_board.dart';
import 'package:kanban/features/kanban/domain/usecases/board/delete_board.dart';
import 'package:kanban/features/kanban/domain/usecases/board/read_boards.dart';
import 'package:kanban/features/kanban/domain/usecases/board/rename_board.dart';
import 'package:kanban/features/kanban/domain/usecases/board/update_board_index.dart';
import 'package:kanban/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/domain/usecases/task_usecases.dart';

final locator = GetIt.instance;

void setUpLocator() {
  // bloc
  locator.registerFactory(() => BoardBloc(
        renameBoard: locator(),
        createBoard: locator(),
        readBoards: locator(),
        updateBoardIndex: locator(),
        deleteBoard: locator(),
      ));
  locator.registerFactory(() => TaskBloc(
      getTaskStream: locator(),
      createTask: locator(),
      updateTask: locator(),
      updateTaskAssigneeUid: locator(),
      updateTaskImportance: locator(),
      updateTaskStatus: locator(),
      deleteTask: locator()));

  // task use cases
  locator.registerLazySingleton(() => CreateTaskUseCase(locator()));
  locator.registerLazySingleton(() => DeleteTaskUseCase(locator()));
  locator.registerLazySingleton(() => GetTaskStreamUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskAssigneeUidUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskImportanceUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskStatusUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskUseCase(locator()));

  // board use cases
  locator.registerLazySingleton(() => CreateBoardUseCase(locator()));
  locator.registerLazySingleton(
      () => DeleteBoardUseCase(boardRepo: locator(), taskRepo: locator()));
  locator.registerLazySingleton(() => ReadBoardsUseCase(locator()));
  locator.registerLazySingleton(
      () => RenameBoardUseCase(boardRepo: locator(), taskRepo: locator()));
  locator.registerLazySingleton(() => UpdateBoardIndexUseCase(locator()));

  // repository
  locator.registerLazySingleton<BoardRepository>(
      () => BoardRepositoryImpl(locator()));
  locator.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(locator()));

  // data source
  locator.registerLazySingleton<BoardDataSource>(() => BoardDataSourceImpl(
      boardsDocReference: FirebaseConstants.boardsDocReference));
  locator.registerLazySingleton<TaskDataSource>(() => TaskDataSourceImpl(
      taskCollectionReference: FirebaseConstants.taskCollectionReference));
}
