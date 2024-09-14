import 'dart:async';

import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';

class FakeBoardRepository extends BoardRepository {
  List<Board> _boardList = [];
  final _controller = StreamController<List<Board>>.broadcast();

  @override
  Future<List<Board>> getBoards() async {
    logger.trace('$FakeBoardRepository: getBoards \n $_boardList');
    return [..._boardList];
  }

  @override
  Stream<List<Board>> readBoards() {
    logger.trace('$FakeBoardRepository: readBoards \n $_boardList');
    return _controller.stream;
  }

  @override
  Future<void> updateBoards(List<Board> boardsList) async {
    logger.trace('$FakeBoardRepository: updateBoards \n'
        'current: $_boardList\n'
        'next: $boardsList');

    _boardList = [...boardsList];
    _controller.add(_boardList);
  }

  void clearPersistence() {
    logger.trace('$FakeBoardRepository: clearPersistence()\n'
        'current: $_boardList\n'
        'next: []');
    _boardList.clear();
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
