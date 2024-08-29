import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vida_a_dois/features/kanban/data/models/board_model.dart';

abstract class BoardDataSource {
  BoardDataSource({required this.boardsDocReference});
  final DocumentReference boardsDocReference;

  Future<List<BoardModel>> getBoards();
  Stream<List<BoardModel>> readBoards();
  Future<void> updateBoards(List<BoardModel> boardsList);
}

class BoardDataSourceImpl extends BoardDataSource {
  BoardDataSourceImpl({required super.boardsDocReference});

  @override
  Future<List<BoardModel>> getBoards() async {
    return _parseSnapshotToBoardList(await boardsDocReference.get());
  }

  @override
  Stream<List<BoardModel>> readBoards() {
    return boardsDocReference.snapshots().map(_parseSnapshotToBoardList);
  }

  @override
  Future<void> updateBoards(List<BoardModel> boardsList) async {
    await boardsDocReference.set({
      'status': boardsList.map((board) => board.title).toList(),
    });
  }

  List<BoardModel> _parseSnapshotToBoardList(DocumentSnapshot snapshot) {
    final list = List<String>.from(snapshot['status']);

    return list
        .map((e) => BoardModel(title: e, index: list.indexOf(e)))
        .toList();
  }
}
