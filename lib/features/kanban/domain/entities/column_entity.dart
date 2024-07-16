class ColumnEntity {
  String title;
  int index;

  ColumnEntity({
    required this.title,
    required this.index,
  });

  Map<String, dynamic> get toJson {
    return {
      'id': title,
      'position': index,
    };
  }
}
