class Board {
  Board({required this.title, required this.index});

  String title;
  int index;

  factory Board.copyFrom(Board board) => Board(
        title: board.title,
        index: board.index,
      );

  Map<String, dynamic> get asMap => {
        'title': title,
        'index': index,
      };

  @override
  String toString() => asMap.toString();

  @override
  bool operator ==(covariant Board other) => toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;
}
