import 'package:get_it/get_it.dart';
import 'package:kanban/features/kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/data/data_sources/board_data_source.dart';
import 'package:kanban/features/kanban/data/data_sources/task_data_source.dart';
import 'package:kanban/features/kanban/data/repositories/board_repository_impl.dart';
import 'package:kanban/features/kanban/data/repositories/task_repository_impl.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';
import 'package:kanban/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/presentation/bloc/task/task_bloc.dart';

final locator = GetIt.instance;

void setUpLocator() {
  // bloc
  locator.registerFactory(() => BoardBloc(locator()));
  locator.registerFactory(() => TaskBloc(locator()));

  // repository
  locator.registerLazySingleton<BoardRepository>(() => BoardRepositoryImpl(
        taskDataSource: locator(),
        boardDataSource: locator(),
      ));
  locator.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(
        taskDataSource: locator(),
      ));

  // data source
  locator.registerLazySingleton<BoardDataSource>(() => BoardDataSource(
        boardsDocReference: FireStoreConstants.boardsDocReference,
        taskDataSource: locator(),
      ));
  locator.registerLazySingleton<TaskDataSource>(() => TaskDataSource(
        taskCollectionReference: FireStoreConstants.taskCollectionReference,
      ));
}
