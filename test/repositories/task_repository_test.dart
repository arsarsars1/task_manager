import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:task_manager/services/connectivity_service.dart';
import 'package:task_manager/services/network_service.dart';

// Generate a MockNetworkService using Mockito
@GenerateMocks([NetworkService])
import 'task_repository_test.mocks.dart';

void main() {
  group('TaskRepository', () {
    late TaskRepository taskRepository;
    late MockNetworkService mockNetworkService;

    setUp(() {
      mockNetworkService = MockNetworkService();
      taskRepository = TaskRepository(
          networkService: mockNetworkService,
          connectivityService: ConnectivityService());
    });

    test('fetchTasks returns tasks from API', () async {
      when(mockNetworkService.getTasks(skip: 0, limit: 10)).thenAnswer(
          (_) async => {"todos": [], "total": 150, "skip": 0, "limit": 10});

      final tasks = await taskRepository.fetchTasks(limit: 10, skip: 0);
      expect(tasks, isNotNull);
    });

    test('createTask returns task from API', () async {
      final taskJson = {
        "id": 1,
        "todo": "Test Task",
        "completed": false,
        "userId": 1
      };
      when(mockNetworkService.createTask(description: 'Test Task'))
          .thenAnswer((_) async => taskJson);

      final task = await taskRepository.addTask(Todo.fromJson(taskJson).todo);
      expect(task, isNotNull);
    });

    test('updateTask updates task via API', () async {
      final taskJson = {
        "id": 1,
        "todo": "Updated Task",
        "completed": true,
        "userId": 1
      };
      when(mockNetworkService.updateTask(any))
          .thenAnswer((_) async => taskJson);

      final task = Todo.fromJson(taskJson);
      final updatedTask = await taskRepository.updateTask(task);
      expect(updatedTask, isNotNull);
    });

    test('deleteTask deletes task via API', () async {
      when(mockNetworkService.deleteTask(taskId: 1))
          .thenAnswer((_) async => Future.value(null));

      await taskRepository.deleteTask(1);
      verify(mockNetworkService.deleteTask(taskId: 1)).called(1);
    });
  });
}
