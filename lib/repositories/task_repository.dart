import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/network_service.dart';

class TaskRepository {
  final NetworkService networkService;

  TaskRepository({required this.networkService});

  Future<TaskModel> fetchTasks({int limit = 10, int skip = 0}) async {
    final response = await networkService.getTasks(skip: skip, limit: limit);
    if (response != null) {
      final tasks = TaskModel.fromJson(response);
      await _saveTasksToPrefs(tasks.todos);
      return tasks;
    } else {
      final todos = await _getTasksFromPrefs();
      return TaskModel(
          todos: todos, total: todos.length, skip: 0, limit: todos.length);
    }
  }

  Future<Todo> addTask(String description) async {
    final response = await networkService.createTask(description: description);
    if (response != null) {
      final newTask = Todo.fromJson(response);
      await _addTaskToPrefs(newTask);
      return newTask;
    } else {
      throw Exception('Failed to add task');
    }
  }

  Future<Todo> updateTask(Todo task) async {
    final response = await networkService.updateTask(task);
    if (response != null) {
      final updatedTask = Todo.fromJson(response);
      await _updateTaskInPrefs(updatedTask);
      return updatedTask;
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final response = await networkService.deleteTask(taskId: taskId);
    if (response != null) {
      await _deleteTaskFromPrefs(taskId);
    } else {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> _saveTasksToPrefs(List<Todo> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks', jsonEncode(tasksJson));
  }

  Future<void> _addTaskToPrefs(Todo task) async {
    final tasks = await _getTasksFromPrefs();
    tasks.add(task);
    await _saveTasksToPrefs(tasks);
  }

  Future<void> _updateTaskInPrefs(Todo task) async {
    final tasks = await _getTasksFromPrefs();
    final taskIndex = tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      tasks[taskIndex] = task;
      await _saveTasksToPrefs(tasks);
    }
  }

  Future<void> _deleteTaskFromPrefs(int taskId) async {
    final tasks = await _getTasksFromPrefs();
    final updatedTasks = tasks.where((task) => task.id != taskId).toList();
    await _saveTasksToPrefs(updatedTasks);
  }

  Future<List<Todo>> _getTasksFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List tasksJson = jsonDecode(tasksString);
      return tasksJson.map((taskJson) => Todo.fromJson(taskJson)).toList();
    }
    return [];
  }
}
