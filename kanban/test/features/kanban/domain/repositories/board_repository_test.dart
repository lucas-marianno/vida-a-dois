import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';
import 'package:kanban/src/injection_container.dart';

import '../../../../helper/fake_board_repository.dart';
import '../../../../helper/fake_task_repository.dart';

void main() async {
  initLogger(Log(level: Level.all));

  setUpLocator(FakeBoardRepository(), FakeTaskRepository());
  final boardRepo = locator<BoardRepository>() as FakeBoardRepository;

  group('testing `FakeBoardRepository`', () {
    setUp(() => boardRepo.clearPersistence());

    test('should get an empty `List<Board>` ', () async {
      final response = await boardRepo.getBoards();

      expect(response, isA<List<Board>>());
      expect(response, isEmpty);
    });

    test('should get a valid `List<Board>`', () async {
      final boardList = [
        const Board(title: 'todo', index: 0),
        const Board(title: 'in progress', index: 1),
        const Board(title: 'done', index: 2),
      ];
      await boardRepo.updateBoards(boardList);

      final response = await boardRepo.getBoards();

      expect(response, isA<List<Board>>());
      expect(response.toString() == boardList.toString(), true);
    });

    test('should get a valid `Stream<List<Board>>` in order', () async {
      // arrange
      const board1 = Board(title: '1', index: 0);
      const board2 = Board(title: '2', index: 1);
      final expectedStream = [
        [],
        [board1],
        [board1, board2]
      ];

      // assert
      expect(boardRepo.readBoards(), emitsInOrder(expectedStream));

      // act
      boardRepo.updateBoards([board1]);
      boardRepo.updateBoards([board1, board2]);
      boardRepo.dispose();
    });
  });
}
