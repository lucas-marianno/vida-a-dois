import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';

class BoardModel extends Board {
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

  factory BoardModel.fromEntity(Board boardEntity) {
    return BoardModel(title: boardEntity.title, index: boardEntity.index);
  }

  Board toEntity() => this;
}
