class Board {
  Board({required this.title, required this.index});

  String title;
  int index;

  factory Board.copyFrom(Board board) => Board(
        title: board.title,
        index: board.index,
      );
}
