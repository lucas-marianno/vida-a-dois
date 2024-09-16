import 'dart:async';
import 'dart:math';

import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';

class FakeTaskRepository extends TaskRepository {
  final _taskList = <Task>[];
  final _controller = StreamController<List<Task>>.broadcast();

  FakeTaskRepository() {
    _controller.stream.listen((data) {
      logger.info('$FakeTaskRepository: emitted \n $data');
    });
  }

  @override
  Future<void> createTask(Task newTask) async {
    logger.trace('$FakeTaskRepository: createTask \n $newTask');

    newTask = newTask.copyWith(id: _generateID());
    _taskList.add(newTask);
    _controller.add([..._taskList]);
  }

  @override
  Future<void> deleteTask(Task task) async {
    logger.trace('$FakeTaskRepository: deleteTask \n $task');

    _taskList.remove(task);
    _controller.add([..._taskList]);
  }

  @override
  Future<List<Task>> getTasks() async {
    logger.trace('$FakeTaskRepository: getTasks \n $_taskList');

    return [..._taskList];
  }

  @override
  Stream<List<Task>> readTasks() {
    logger.trace('$FakeTaskRepository: readTasks \n current:\n $_taskList');

    _controller.onListen = () => _controller.add([..._taskList]);
    return _controller.stream;
  }

  @override
  Future<void> updateTask(Task task) async {
    logger.trace('$FakeTaskRepository: updateTask \n $task');

    final i = _taskList.indexWhere((t) => t.id == task.id);

    if (i < 0) {
      _taskList.add(task);
    } else {
      _taskList[i] = task;
    }

    _controller.add([..._taskList]);
  }

  void clearPersistence() {
    logger.trace('$FakeTaskRepository: clearPersistence');

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
