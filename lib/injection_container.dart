import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vida_a_dois/features/kanban/data/cloud_firestore/firestore_references.dart';
import 'package:vida_a_dois/features/kanban/data/data_sources/board_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/data_sources/task_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/repositories/board_repository_impl.dart';
import 'package:vida_a_dois/features/kanban/data/repositories/task_repository_impl.dart';

import 'package:vida_a_dois/features/kanban/domain/repository/board_repository.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/task_repository.dart';
import 'package:vida_a_dois/features/kanban/domain/usecases/board_usecases.dart';
import 'package:vida_a_dois/features/kanban/domain/usecases/task_usecases.dart';

import 'package:vida_a_dois/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/task/task_bloc.dart';

final locator = GetIt.instance;

void setUpLocator(FirebaseFirestore firebaseFirestore) {
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
  locator.registerLazySingleton(() => CreateTaskUseCase(locator()));
  locator.registerLazySingleton(() => DeleteTaskUseCase(locator()));
  locator.registerLazySingleton(() => GetTaskStreamUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskAssigneeUidUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskImportanceUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskStatusUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskUseCase(locator()));

  // board use cases
  locator.registerLazySingleton(() => CreateInitialBoardUseCase(locator()));
  locator.registerLazySingleton(() => CreateBoardUseCase(locator()));
  locator.registerLazySingleton(
      () => DeleteBoardUseCase(boardRepo: locator(), taskRepo: locator()));
  locator.registerLazySingleton(() => ReadBoardsUseCase(locator()));
  locator.registerLazySingleton(
      () => RenameBoardUseCase(boardRepo: locator(), taskRepo: locator()));
  locator.registerLazySingleton(() => UpdateBoardIndexUseCase(locator()));

  // repositories
  locator.registerLazySingleton<BoardRepository>(
      () => BoardRepositoryImpl(locator()));
  locator.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(locator()));

  // data sources
  locator.registerLazySingleton<BoardDataSource>(() => BoardDataSourceImpl(
      boardsDocReference:
          FirestoreReferencesImpl(firebaseFirestore).boardsDocRef));
  locator.registerLazySingleton<TaskDataSource>(() => TaskDataSourceImpl(
      taskCollectionReference:
          FirestoreReferencesImpl(firebaseFirestore).taskCollectionRef));
}
