import 'dart:async';
import 'dart:math';

import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';

class FakeTaskRepository extends TaskRepository {
  final _taskList = <Task>[];
  final _controller = StreamController<List<Task>>.broadcast();

  @override
  Future<void> createTask(Task newTask) async {
    newTask = newTask.copyWith(id: _generateID());
    _taskList.add(newTask);
    _controller.add([..._taskList]);
  }

  @override
  Future<void> deleteTask(Task task) async {
    _taskList.remove(task);
    _controller.add([..._taskList]);
  }

  @override
  Future<List<Task>> getTasks() async {
    return [..._taskList];
  }

  @override
  Stream<List<Task>> readTasks() {
    _controller.onListen = () => _controller.add([..._taskList]);
    return _controller.stream;
  }

  @override
  Future<void> updateTask(Task task) async {
    final i = _taskList.indexWhere((t) => t.id == task.id);

    if (i < 0) {
      _taskList.add(task);
    } else {
      _taskList[i] = task;
    }

    _controller.add([..._taskList]);
  }

  Future<void> clearPersistence() async {
    _taskList.clear();
    _controller.add([..._taskList]);
  }

  String _generateID() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();

    return List.generate(
        20, (index) => characters[random.nextInt(characters.length)]).join();
  }
}
