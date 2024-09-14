import 'package:flutter_test/flutter_test.dart';

import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';

import 'package:kanban/src/injection_container.dart';
import 'package:kanban/src/presentation/bloc/board/board_bloc.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/mock_generator.mocks.dart';

void main() async {
  await locator.reset();

  initLogger(Log(level: Level.all));

  setUpLocator(MockBoardRepository(), MockTaskRepository());

  final boardRepo = locator<BoardRepository>();
  late final BoardBloc boardBloc;

  late List<Board> boardList;

  setUpAll(() {
    boardList = [const Board(title: 'to do', index: 0)];
    when(boardRepo.readBoards()).thenAnswer((_) => Stream.value(boardList));

    boardBloc = locator<BoardBloc>();
  });

  test('should return BoardLoadedState()', () {
    // verify(() => boardRepo.readBoards()).called(1);
    expect(boardBloc.state, BoardLoadedState(boardList));
  });
}
