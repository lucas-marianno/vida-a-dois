import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/domain/entities/board_entity.dart';

import '../../../../helper/fake_board_repository.dart';

void main() async {
  initLogger(Log(level: Level.all));

  group('testing `FakeBoardRepository`', () {
    final boardRepo = FakeBoardRepository();

    setUp(() => boardRepo.clearPersistence());

    test('should get an empty `List<Board>` ', () async {
      final response = await boardRepo.getBoards();

      expect(response, isA<List<Board>>());
      expect(response.isEmpty, true);
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

    // test('should get a valid `Stream<Board>`', () async {
    //   // arrange
    //   const board1 = Board(title: '1', index: 0);
    //   const board2 = Board(title: '2', index: 1);
    //   final expectedStream = [
    //     [],
    //     [board1],
    //     [board1, board2]
    //   ];
    //   late final StreamSubscription thisStream;

    //   // assert
    //   int i = 0;
    //   onData(data) {
    //     expect(data, expectedStream[i]);
    //     i++;

    //     if (i == expectedStream.length) thisStream.cancel();
    //   }

    //   thisStream = boardRepo.readBoards().listen(onData);

    //   // act
    //   await boardRepo.updateBoards([board1]);
    //   await boardRepo.updateBoards([board1, board2]);
    // });
    test('should get a valid `Stream<Board>` in order', () async {
      // arrange
      const board1 = Board(title: '1', index: 0);
      const board2 = Board(title: '2', index: 1);
      final expectedStream = [
        [],
        [board1],
        [board1, board2]
      ];
      final stream = boardRepo.readBoards();

      // act
      await boardRepo.updateBoards([board1]);
      await boardRepo.updateBoards([board1, board2]);
      await boardRepo.dispose();

      // assert
      expect(stream, emitsInOrder(expectedStream));
    });
  });
}
