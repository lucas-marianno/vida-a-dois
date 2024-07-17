class ColumnEntity {
  String title;
  int? index;

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

  ColumnEntity copy() => ColumnEntity.fromJson(toJson);
}
