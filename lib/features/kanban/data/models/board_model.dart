import 'package:kanban/features/kanban/domain/entities/board_entity.dart';

class BoardModel extends BoardEntity {
  BoardModel({required super.title, required super.index});

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      title: json['title'],
      index: json['index'],
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'title': title,
      'index': index,
    };
  }

  factory BoardModel.fromEntity(BoardEntity boardEntity) {
    return BoardModel(title: boardEntity.title, index: boardEntity.index);
  }

  BoardEntity toEntity() => this;

  /// Returns a new [BoardModel] with the same values as the original.
  BoardModel copy() => BoardModel.fromJson(toJson);

  /// [equalsTo] makes a deep comparison between two [BoardModel] objects
  /// and returns `true` if all parameters match.
  bool equalsTo(BoardModel board) => '${board.toJson}' == '$toJson';
}
