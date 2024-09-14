import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';
import 'package:kanban/src/injection_container.dart';
import 'package:mockito/mockito.dart';
import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/usecases/board_usecases.dart';

import '../../../../../helper/mock_generator.mocks.dart';

void main() {
  setUpLocator(MockBoardRepository(), MockTaskRepository());

  final boardRepo = locator<BoardRepository>();

  group('testing ReadBoardUseCase', () {
    final readBoard = ReadBoardsUseCase(boardRepo);

    test('should stream an empty list of boards', () {
      // arrange
      when(boardRepo.readBoards()).thenAnswer((_) => Stream.value([]));

      // act
      final response = readBoard();

      // assert
      expect(response, emitsInOrder([]));
    });

    test('should stream a proper list of boards', () {
      // arrange
      List<Board> mockBoardsList = [
        const Board(title: 'todo', index: 0),
        const Board(title: 'in progress', index: 1),
        const Board(title: 'done', index: 2),
      ];
      when(boardRepo.readBoards())
          .thenAnswer((_) => Stream.value(mockBoardsList));

      // act
      final response = readBoard();

      // assert
      expect(response, emitsInOrder([mockBoardsList]));
    });
  });
}
