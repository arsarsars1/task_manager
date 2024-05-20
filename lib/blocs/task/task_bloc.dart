import 'package:bloc/bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/blocs/task/task_state.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/repositories/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  bool isFetching = false;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<FetchTasks>(_onFetchTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onFetchTasks(FetchTasks event, Emitter<TaskState> emit) async {
    if (isFetching) return;
    final currentState = state;
    if (currentState is TaskLoaded && currentState.hasReachedMax) return;

    isFetching = true;
    var oldTasks = <Todo>[];
    if (currentState is TaskLoaded) {
      oldTasks = currentState.tasks;
    }

    try {
      if (event.skip == 0) {
        emit(TaskLoading());
      } else {
        emit((currentState as TaskLoaded).copyWith(isBottomLoading: true));
      }

      final taskModel =
          await taskRepository.fetchTasks(limit: event.limit, skip: event.skip);
      final tasks = taskModel.todos;
      final totalTasks = taskModel.total;

      final hasReachedMax = oldTasks.length + tasks.length >= totalTasks;

      emit(TaskLoaded(
        tasks: oldTasks + tasks,
        hasReachedMax: hasReachedMax,
        isBottomLoading: false,
      ));
    } catch (error) {
      emit(TaskError(error: error.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      try {
        emit(TaskUpdating());
        final newTask = await taskRepository.addTask(event.task.todo);
        final updatedTasks = List<Todo>.from(currentState.tasks)..add(newTask);
        emit(TaskLoaded(tasks: updatedTasks, hasReachedMax: false));
      } catch (error) {
        emit(TaskError(error: error.toString()));
      }
    } else {
      emit(const TaskError(error: 'Failed to add task'));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      try {
        emit(TaskUpdating());
        final updatedTask = await taskRepository.updateTask(event.task);
        final updatedTasks = currentState.tasks.map((task) {
          return task.id == updatedTask.id ? updatedTask : task;
        }).toList();
        emit(TaskLoaded(
            tasks: updatedTasks, hasReachedMax: currentState.hasReachedMax));
      } catch (error) {
        emit(TaskError(error: error.toString()));
      }
    } else {
      emit(const TaskError(error: 'Failed to update task'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      try {
        emit(TaskDeleting());
        await taskRepository.deleteTask(event.taskId);
        final updatedTasks = currentState.tasks
            .where((task) => task.id != event.taskId)
            .toList();
        emit(TaskLoaded(
            tasks: updatedTasks, hasReachedMax: currentState.hasReachedMax));
      } catch (error) {
        emit(TaskError(error: error.toString()));
      }
    } else {
      emit(const TaskError(error: 'Failed to delete task'));
    }
  }
}
