import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/core/network/endpoints.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/network_service.dart';

// Generate a MockHttpClient using Mockito
@GenerateMocks([http.Client])
import 'network_service_test.mocks.dart';

void main() {
  group('NetworkService', () {
    late NetworkService networkService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      networkService = NetworkService(mockClient);
    });

    test('fetchTasks returns tasks from API', () async {
      final response = http.Response(
          '{"todos": [], "total": 150, "skip": 0, "limit": 10}', 200);
      when(mockClient.get(Uri.parse('${Endpoints.todos}?limit=10&skip=0')))
          .thenAnswer((_) async => response);

      final tasks = await networkService.getTasks(skip: 0, limit: 10);
      expect(tasks, isNotNull);
    });

    test('createTask returns task from API', () async {
      final response = http.Response(
          '{"id": 1, "todo": "Test Task", "completed": false, "userId": 1}',
          200);
      when(mockClient.post(
        Uri.parse(Endpoints.todoAdd),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => response);

      final task = await networkService.createTask(description: 'Test Task');
      expect(task, isNotNull);
    });

    test('updateTask updates task via API', () async {
      final task = Todo(
        id: 1,
        todo: 'Updated Task',
        completed: true,
        userId: 1,
      );
      final response = http.Response(
          '{"id": 1, "todo": "Updated Task", "completed": true, "userId": 1}',
          200);
      when(mockClient.put(
        Uri.parse('${Endpoints.todos}/${task.id}'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => response);

      final updatedTask = await networkService.updateTask(task);
      expect(updatedTask, isNotNull);
    });

    test('deleteTask deletes task via API', () async {
      final response = http.Response('{"id": 1}', 200);
      when(mockClient.delete(
        Uri.parse('${Endpoints.todos}/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => response);

      final result = await networkService.deleteTask(taskId: 1);
      expect(result, isNotNull);
    });
  });
}
