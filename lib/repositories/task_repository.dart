import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/connectivity_service.dart';
import 'package:task_manager/services/network_service.dart';

class TaskRepository {
  final ConnectivityService connectivityService;
  final NetworkService networkService;

  TaskRepository(
      {required this.networkService, required this.connectivityService});

  Future<TaskModel> fetchTasks({int limit = 10, int skip = 0}) async {
    final isConnected = await connectivityService.isConnected();
    if (isConnected) {
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
    } else {
      var list = await _getTasksFromLocal();
      return TaskModel(todos: list, total: list.length, skip: 0, limit: 0);
    }
  }

  Future<Todo> addTask(String description) async {
    final isConnected = await connectivityService.isConnected();
    if (isConnected) {
      final response =
          await networkService.createTask(description: description);
      if (response != null) {
        final newTask = Todo.fromJson(response);
        await _addTaskToPrefs(newTask);
        return newTask;
      } else {
        throw Exception('Failed to add task');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<Todo> updateTask(Todo task) async {
    final isConnected = await connectivityService.isConnected();
    if (isConnected) {
      final response = await networkService.updateTask(task);
      if (response != null) {
        final updatedTask = Todo.fromJson(response);
        await _updateTaskInPrefs(updatedTask);
        return updatedTask;
      } else {
        throw Exception('Failed to update task');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final isConnected = await connectivityService.isConnected();
    if (isConnected) {
      final response = await networkService.deleteTask(taskId: taskId);
      if (response != null) {
        await _deleteTaskFromPrefs(taskId);
      } else {
        throw Exception('Failed to delete task');
      }
    } else {
      throw Exception('No internet connection');
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

  Future<List<Todo>> _getTasksFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List tasksJson = jsonDecode(tasksString);
      return tasksJson.map((taskJson) => Todo.fromJson(taskJson)).toList();
    }
    return [];
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
