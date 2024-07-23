import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';

part 'board_data_source_exception.dart';

/// [BoardDataSource] provides Firebase integration for CRUD operations
abstract class BoardDataSource {
  static final DocumentReference _firebase =
      FireStoreConstants.boardsDocReference;

  static Future<void> createBoard(BoardEntity? board) async {
    if (board == null) return;
    final List<BoardEntity> boards = await _getBoards;

    if (boards.map((e) => e.title).contains(board.title)) {
      throw _BoardUniqueNameException();
    }
    board.index = board.index.clamp(0, boards.length);

    if (board.index >= boards.length) {
      boards.add(board);
    } else {
      boards.insert(board.index, board);
    }
    await _updateBoards(boards);
  }

  static Future<void> updateBoard(
    BoardEntity board,
    BoardEntity newBoard,
  ) async {
    if (board.equals(newBoard)) return;

    await updateBoardTitle(board, newBoard.title);
    await _updateBoardIndex(board..title = newBoard.title, newBoard.index);
  }

  static Future<void> updateBoardTitle(
    BoardEntity board,
    String newTitle,
  ) async {
    if (board.title == newTitle) return;

    final boards = await _getBoards;
    boards[board.index] = (board.copy()..title = newTitle);

    await Future.wait([
      TaskDataSource.updateTasksStatusToNewStatus(board.title, newTitle),
      _updateBoards(boards),
    ]);
  }

  static Future<void> _updateBoardIndex(
    BoardEntity board,
    int newIndex,
  ) async {
    if (board.index == newIndex) return;

    newIndex = board.index <= newIndex ? newIndex - 1 : newIndex;

    await deleteBoard(board);
    await createBoard(board..index = newIndex);
  }

  static Future<void> _updateBoards(List<BoardEntity> boardsList) async {
    final boards = [];
    for (BoardEntity element in boardsList) {
      boards.add(element.title);
    }

    await _firebase.set({'status': boards});
  }

  static Stream<List<BoardEntity>> get readBoards {
    return _firebase.snapshots().map((snapshot) {
      final List<BoardEntity> a = [];
      for (int i = 0; i < snapshot['status'].length; i++) {
        a.add(BoardEntity(title: snapshot['status'][i], index: i));
      }
      return a;
    });
  }

  static Future<void> deleteBoard(BoardEntity board) async {
    final boards = await _getBoards;
    boards.removeWhere((e) => e.title == board.title);
    return _updateBoards(boards);
  }

  static Future<List<BoardEntity>> get _getBoards async {
    final a = List<String>.from((await _firebase.get())['status']);

    return a.map((e) => BoardEntity(title: e, index: a.indexOf(e))).toList();
  }
}
