class Board {
  String title;
  int index;

  Board({
    required this.title,
    required this.index,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
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

  /// Returns a new [Board] with the same values as the original.
  Board copy() => Board.fromJson(toJson);

  /// [equalsTo] makes a deep comparison between two [Board] objects
  /// and returns `true` if all parameters match.
  bool equalsTo(Board board) => '${board.toJson}' == '$toJson';
}
