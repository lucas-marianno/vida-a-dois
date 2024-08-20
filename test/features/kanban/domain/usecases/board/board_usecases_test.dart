import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/exceptions/kanban_exception.dart';
import 'package:vida_a_dois/features/kanban/domain/usecases/board_usecases.dart';

import '../../../../../helper/mock_generator.mocks.dart';

void main() {
  // ensure that the repo is actually called

  final MockBoardRepository boardRepo = MockBoardRepository();
  List<Board> mockBoardsList = [
    Board(title: 'todo', index: 0),
    Board(title: 'in progress', index: 1),
    Board(title: 'done', index: 2),
  ];

  group('testing CreateBoardUseCase', () {
    late CreateBoardUseCase createBoard;

    setUp(() {
      createBoard = CreateBoardUseCase(boardRepo);
      when(boardRepo.getBoards()).thenAnswer((_) async => mockBoardsList);
      when(boardRepo.updateBoards(mockBoardsList)).thenAnswer((_) async {});
    });

    test('should call BoardRepository and not throw any errors', () async {
      // arrange
      Board testBoard = Board(title: 'title', index: 0);

      // act
      await createBoard.call(testBoard);
    });

    test('should throw EmptyNameException', () {
      // arrange
      Board testBoard = Board(title: '', index: 0);

      // act
      final response = createBoard.call(testBoard);

      // assert
      expect(response, throwsA(isA<EmptyNameException>()));
    });
    test('should throw InvalidBoardIndex', () {
      // arrange
      Board testBoard1 = Board(title: 'title', index: 999);
      Board testBoard2 = Board(title: 'title', index: -1);

      // act
      final response1 = createBoard.call(testBoard1);
      final response2 = createBoard.call(testBoard2);

      // assert
      expect(response1, throwsA(isA<InvalidBoardIndex>()));
      expect(response2, throwsA(isA<InvalidBoardIndex>()));
    });
    test('should throw NameNotUniqueException', () {
      // arrange
      Board testBoard = Board(title: 'todo', index: 0);

      // act
      final response = createBoard.call(testBoard);

      // assert
      expect(response, throwsA(isA<NameNotUniqueException>()));
    });
  });
}
