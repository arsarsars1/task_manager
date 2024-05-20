import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/network_service.dart';

class TaskRepository {
  final NetworkService networkService;

  TaskRepository({required this.networkService});

  Future<List<Task>> fetchTasks({int limit = 10, int skip = 0}) async {
    try {
      final response =
          await networkService.getTasks(pageNo: skip, limit: limit);
      if (response != null && response.status) {
        final tasks = (response.data!['todos'] as List)
            .map((taskJson) => Task.fromJson(taskJson))
            .toList();
        await _saveTasksToPrefs(tasks);
        return tasks;
      } else {
        return await _getTasksFromPrefs();
      }
    } catch (error) {
      return await _getTasksFromPrefs();
    }
  }

  Future<Task> addTask(Task task) async {
    try {
      final response = await networkService.createTask(description: task.todo);
      if (response != null && response.status && response.data != null) {
        final newTask = Task.fromJson(response.data!);
        await _addTaskToPrefs(newTask);
        return newTask;
      } else {
        throw Exception('Failed to add task via API');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final response = await networkService.updateTask(task);
      if (response != null && response.status && response.data != null) {
        final updatedTask = Task.fromJson(response.data!);
        await _updateTaskInPrefs(updatedTask);
        return updatedTask;
      } else {
        throw Exception('Failed to update task via API');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      final response = await networkService.deleteTask(taskId: taskId);
      if (response != null && response.status) {
        await _deleteTaskFromPrefs(taskId);
      } else {
        throw Exception('Failed to delete task via API');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> _saveTasksToPrefs(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks', jsonEncode(tasksJson));
  }

  Future<void> _addTaskToPrefs(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await _getTasksFromPrefs();
    tasks.add(task);
    await _saveTasksToPrefs(tasks);
  }

  Future<void> _updateTaskInPrefs(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await _getTasksFromPrefs();
    final taskIndex = tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      tasks[taskIndex] = task;
      await _saveTasksToPrefs(tasks);
    }
  }

  Future<void> _deleteTaskFromPrefs(int taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await _getTasksFromPrefs();
    final updatedTasks = tasks.where((task) => task.id != taskId).toList();
    await _saveTasksToPrefs(updatedTasks);
  }

  Future<List<Task>> _getTasksFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List tasksJson = jsonDecode(tasksString);
      return tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList();
    }
    return [];
  }
}
