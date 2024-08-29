import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vida_a_dois/features/kanban/data/cloud_firestore/firestore_references.dart';
import 'package:vida_a_dois/features/kanban/data/data_sources/board_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/models/board_model.dart';

//  Future<List<BoardModel>> getBoards();
//  Stream<List<BoardModel>> readBoards();
//  Future<void> updateBoards(List<BoardModel> boardsList);
void main() async {
  // should get a proper list of board model from DB

  // should get a proper stream from DB

  // should yield a new List<BoardModel> after `updateBoards` is called

  group('board data source test', () {
    final fakeFirestore = FakeFirebaseFirestore();
    final fakeFirestoreConstants = FirestoreReferencesImpl(fakeFirestore);
    final boardsRef = fakeFirestoreConstants.boardsDocRef;

    final BoardDataSource boardDataSource =
        BoardDataSourceImpl(boardsDocReference: boardsRef);
    setUp(() async {
      await fakeFirestore.clearPersistence();
      await boardDataSource.updateBoards([]);
    });
    test('should get an empty `List<BoardModel>` ', () async {
      final response = await boardDataSource.getBoards();

      expect(response, isA<List<BoardModel>>());
      expect(response.isEmpty, true);
    });

    test('should get a valid `List<BoardModel>`', () async {
      final boardList = [
        BoardModel(title: 'todo', index: 0),
        BoardModel(title: 'in progress', index: 1),
        BoardModel(title: 'done', index: 2),
      ];
      await boardDataSource.updateBoards(boardList);

      final response = await boardDataSource.getBoards();

      expect(response, isA<List<BoardModel>>());
      expect(response.toString() == boardList.toString(), true);
    });
    test('should get a valid `Stream<BoardModel>`', () async {
      // arrange

      final board1 = BoardModel(title: '1', index: 0);
      final board2 = BoardModel(title: '2', index: 1);
      final expectedStream = [
        [],
        [board1],
        [board1, board2]
      ];
      late final StreamSubscription thisStream;

      // assert
      int i = 0;
      onData(data) {
        expect(data, expectedStream[i]);
        i++;

        if (i == expectedStream.length) thisStream.cancel();
      }

      thisStream = boardDataSource.readBoards().listen(onData);

      // act
      await boardDataSource.updateBoards([board1]);
      await boardDataSource.updateBoards([board1, board2]);
    });
  });
}
