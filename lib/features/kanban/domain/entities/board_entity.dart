/// TODO: rename from `BoardEntity` to `Board`
class BoardEntity {
  String title;
  int index;

  BoardEntity({
    required this.title,
    required this.index,
  });

  factory BoardEntity.fromJson(Map<String, dynamic> json) {
    return BoardEntity(
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

  /// Returns a new [BoardEntity] with the same values as the original.
  BoardEntity copy() => BoardEntity.fromJson(toJson);

  /// [equalsTo] makes a deep comparison between two [BoardEntity] objects
  /// and returns `true` if all parameters match.
  bool equalsTo(BoardEntity board) => '${board.toJson}' == '$toJson';
}
