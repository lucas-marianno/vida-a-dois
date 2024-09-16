import 'dart:async';

import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';

class FakeBoardRepository extends BoardRepository {
  List<Board> _boardList = [];
  final _controller = StreamController<List<Board>>.broadcast();

  FakeBoardRepository() {
    _controller.stream.listen((data) {
      logger.info('$FakeBoardRepository: emitted \n $data');
    });
  }

  @override
  Future<List<Board>> getBoards() async {
    logger.trace('$FakeBoardRepository: getBoards \n $_boardList');
    return [..._boardList];
  }

  @override
  Stream<List<Board>> readBoards() {
    logger.trace('$FakeBoardRepository: readBoards \n $_boardList');

    _controller.onListen = () => _controller.add([..._boardList]);

    return _controller.stream;
  }

  @override
  Future<void> updateBoards(List<Board> boardList) async {
    logger.trace('$FakeBoardRepository: updateBoards \n'
        'current: $_boardList\n'
        'next: $boardList');

    _boardList = [...boardList];
    _controller.add([..._boardList]);
  }

  void clearPersistence() {
    logger.trace('$FakeBoardRepository: clearPersistence()\n'
        'current: $_boardList\n'
        'next: []');
    _boardList.clear();
    _controller.add([]);
  }

  Future<void> dispose() async {
    logger.trace('$FakeBoardRepository: closing');
    await _controller.close();
  }
}
