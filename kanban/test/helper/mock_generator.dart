import 'package:mockito/annotations.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';

/// Generates mocks for the following classes
///
/// Run `build_runner` in order to generate
///
/// `dart run build_runner build`
@GenerateMocks([TaskRepository, BoardRepository])
void main() {}
