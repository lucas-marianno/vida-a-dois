import 'package:get_it/get_it.dart';

import 'package:kanban/src/domain/repository/board_repository.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';
import 'package:kanban/src/domain/usecases/board_usecases.dart';
import 'package:kanban/src/domain/usecases/task_usecases.dart';

import 'package:kanban/src/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/src/presentation/bloc/task/task_bloc.dart';

final locator = GetIt.instance;

void setUpLocator(BoardRepository boardRepo, TaskRepository taskRepo) {
  // constants
  const fakeUserID = 'abc123'; // TODO: this will probably be an injection

  // blocs
  locator.registerFactory(() => BoardBloc(
        createInitialBoard: locator(),
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
      updateTaskAssigneeUID: locator(),
      updateTaskImportance: locator(),
      updateTaskStatus: locator(),
      deleteTask: locator()));

  // task use cases
  locator.registerLazySingleton(() => CreateTaskUseCase(locator(), fakeUserID));
  locator.registerLazySingleton(() => DeleteTaskUseCase(locator()));
  locator.registerLazySingleton(() => GetTasksUseCase(locator(), locator()));
  locator.registerLazySingleton(() => UpdateTaskAssigneeUidUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskImportanceUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskStatusUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskUseCase(locator()));

  // board use cases
  locator.registerLazySingleton(() => CreateInitialBoardUseCase(locator()));
  locator.registerLazySingleton(() => CreateBoardUseCase(locator()));
  locator.registerLazySingleton(() => DeleteBoardUseCase(locator(), locator()));
  locator.registerLazySingleton(() => ReadBoardsUseCase(locator()));
  locator.registerLazySingleton(() => RenameBoardUseCase(locator(), locator()));
  locator.registerLazySingleton(() => UpdateBoardIndexUseCase(locator()));

  // repositories
  locator.registerLazySingleton<BoardRepository>(() => boardRepo);
  locator.registerLazySingleton<TaskRepository>(() => taskRepo);
}
