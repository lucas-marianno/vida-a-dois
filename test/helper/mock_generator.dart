import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/board_repository.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/task_repository.dart';

/// Generates mocks for the following classes
///
/// Run `build_runner` in order to generate
///
/// `dart run build_runner build`
@GenerateMocks([
  TaskRepository,
  BoardRepository,
  // TaskDataSource,
  // BoardDataSource,
  Connectivity,
])
void main() {}
