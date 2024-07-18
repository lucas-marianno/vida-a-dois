class ColumnEntity {
  String title;
  int index;

  ColumnEntity({
    required this.title,
    required this.index,
  });

  factory ColumnEntity.fromJson(Map<String, dynamic> json) {
    return ColumnEntity(
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

  /// Returns a new [ColumnEntity] with the same values as the original.
  ColumnEntity copy() => ColumnEntity.fromJson(toJson);

  /// Compares each item value in both columns and returns [true] or [false].
  bool equals(ColumnEntity column) => '${column.toJson}' == '$toJson';
}
