import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/blocs/task/task_state.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:test/test.dart';

// Mock class for TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  group('TaskBloc', () {
    late TaskBloc taskBloc;
    late MockTaskRepository mockTaskRepository;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      taskBloc = TaskBloc(taskRepository: mockTaskRepository);
    });

    tearDown(() {
      taskBloc.close();
    });

    test('initial state is TaskInitial', () {
      expect(taskBloc.state, TaskInitial());
    });

    final todo = Todo(
      id: 1,
      todo: 'Test Task',
      completed: false,
      userId: 1,
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskDeleting, TaskLoaded] when DeleteTask is added',
      build: () {
        when(mockTaskRepository.deleteTask(1)).thenAnswer((_) async {});
        return taskBloc;
      },
      act: (bloc) {
        bloc.emit(TaskLoaded(
          tasks: [todo],
          hasReachedMax: false,
        ));
        bloc.add(const DeleteTask(taskId: 1));
      },
      expect: () => [
        TaskDeleting(),
        const TaskLoaded(tasks: [], hasReachedMax: false),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskLoaded] when FetchTasks is added',
      build: () {
        when(mockTaskRepository.fetchTasks(limit: 10, skip: 0));
        return taskBloc;
      },
      act: (bloc) => bloc.add(const FetchTasks(limit: 10, skip: 0)),
      expect: () => [
        TaskLoading(),
        TaskLoaded(tasks: [todo], hasReachedMax: false),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskUpdating, TaskLoaded] when UpdateTask is added',
      build: () {
        when(mockTaskRepository.updateTask(todo))
            .thenAnswer((_) async => todo.copyWith(todo: 'Updated Task'));
        return taskBloc;
      },
      act: (bloc) {
        bloc.emit(TaskLoaded(
          tasks: [todo],
          hasReachedMax: false,
        ));
        bloc.add(UpdateTask(task: todo.copyWith(todo: 'Updated Task')));
      },
      expect: () => [
        TaskUpdating(),
        TaskLoaded(
            tasks: [todo.copyWith(todo: 'Updated Task')], hasReachedMax: false),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskAdding, TaskLoaded] when AddTask is added',
      build: () {
        when(mockTaskRepository.addTask(todo.todo))
            .thenAnswer((_) async => todo);
        return taskBloc;
      },
      act: (bloc) => bloc.add(AddTask(task: todo)),
      expect: () => [
        TaskAdding(),
        TaskLoaded(tasks: [todo], hasReachedMax: false),
      ],
    );
  });
}
