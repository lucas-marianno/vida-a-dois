import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/data/models/board_model.dart';

abstract class BoardDataSource {
  final DocumentReference boardsDocReference;
  BoardDataSource({required this.boardsDocReference});

  Future<void> updateBoards(List<BoardModel> boardsList);

  Stream<List<BoardModel>> readBoards();

  Future<List<BoardModel>> getBoards();
}

class BoardDataSourceImpl extends BoardDataSource {
  BoardDataSourceImpl({required super.boardsDocReference});

  @override
  Future<void> updateBoards(List<BoardModel> boardsList) async {
    final boards = <String>[];
    for (BoardModel board in boardsList) {
      boards.add(board.title);
    }

    await boardsDocReference.set({'status': boards});
  }

  @override
  Stream<List<BoardModel>> readBoards() {
    return boardsDocReference.snapshots().map((snapshot) {
      final List<BoardModel> a = [];
      for (int i = 0; i < snapshot['status'].length; i++) {
        a.add(BoardModel(title: snapshot['status'][i], index: i));
      }
      return a;
    });
  }

  @override
  Future<List<BoardModel>> getBoards() async {
    final a = List<String>.from((await boardsDocReference.get())['status']);

    return a.map((e) => BoardModel(title: e, index: a.indexOf(e))).toList();
  }
}
