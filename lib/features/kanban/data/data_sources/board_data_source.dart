import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/data/data_sources/task_data_source.dart';
import 'package:kanban/features/kanban/data/models/board_model.dart';
import 'package:kanban/features/kanban/domain/exceptions/board_exception.dart';

/// [BoardDataSource] provides Firebase integration for CRUD operations
class BoardDataSource {
  BoardDataSource({
    required this.boardsDocReference,
    required this.taskDataSource,
  });
  final TaskDataSource taskDataSource;
  final DocumentReference boardsDocReference;

  Future<void> createBoard(BoardModel? board) async {
    if (board == null) return;
    final List<BoardModel> boards = await _getBoards;

    if (boards.map((e) => e.title).contains(board.title)) {
      throw NameNotUniqueException();
    }
    board.index = board.index.clamp(0, boards.length);

    if (board.index >= boards.length) {
      boards.add(board);
    } else {
      boards.insert(board.index, board);
    }
    await _updateBoards(boards);
  }

  Future<void> updateBoard(BoardModel board, BoardModel newBoard) async {
    // if (board.equalsTo(newBoard)) return;

    await updateBoardTitle(board, newBoard.title);
    await _updateBoardIndex(board..title = newBoard.title, newBoard.index);
  }

  Future<void> updateBoardTitle(BoardModel board, String newTitle) async {
    if (board.title == newTitle) return;

    final boards = await _getBoards;

    if (boards.map((e) => e.title).contains(board.title)) {
      throw NameNotUniqueException();
    }

    boards[board.index] = (board.copy()..title = newTitle);

    await Future.wait([
      taskDataSource.updateTasksStatusToNewStatus(board.title, newTitle),
      _updateBoards(boards),
    ]);
  }

  Future<void> _updateBoardIndex(
    BoardModel board,
    int newIndex,
  ) async {
    if (board.index == newIndex) return;

    newIndex = board.index <= newIndex ? newIndex - 1 : newIndex;

    await deleteBoard(board);
    await createBoard(board..index = newIndex);
  }

  Future<void> _updateBoards(List<BoardModel> boardsList) async {
    final boards = [];
    for (BoardModel element in boardsList) {
      boards.add(element.title);
    }

    await boardsDocReference.set({'status': boards});
  }

  Stream<List<BoardModel>> get readBoards {
    return boardsDocReference.snapshots().map((snapshot) {
      final List<BoardModel> a = [];
      for (int i = 0; i < snapshot['status'].length; i++) {
        a.add(BoardModel(title: snapshot['status'][i], index: i));
      }
      return a;
    });
  }

  Future<void> deleteBoard(BoardModel board) async {
    final boards = await _getBoards;
    boards.removeWhere((e) => e.title == board.title);
    return _updateBoards(boards);
  }

  Future<List<BoardModel>> get _getBoards async {
    final a = List<String>.from((await boardsDocReference.get())['status']);

    return a.map((e) => BoardModel(title: e, index: a.indexOf(e))).toList();
  }
}
