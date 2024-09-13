class Board {
  const Board({required this.title, required this.index});

  final String title;
  final int index;

  Board copyWith({String? title, int? index}) {
    return Board(
      title: title ?? this.title,
      index: index ?? this.index,
    );
  }

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
