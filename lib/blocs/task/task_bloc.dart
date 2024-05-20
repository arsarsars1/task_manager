import 'package:bloc/bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/blocs/task/task_state.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/repositories/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<FetchTasks>(_mapFetchTasksToState);
    on<AddTask>(_mapAddTaskToState);
    on<UpdateTask>(_mapUpdateTaskToState);
    on<DeleteTask>(_mapDeleteTaskToState);
  }

  Future<void> _mapFetchTasksToState(
      FetchTasks event, Emitter<TaskState> emit) async {
    try {
      emit(TaskLoading());
      final currentState = state;
      var oldTasks = <Task>[];
      if (currentState is TaskLoaded) {
        oldTasks = currentState.tasks;
      }

      final tasks =
          await taskRepository.fetchTasks(limit: event.limit, skip: event.skip);
      emit(TaskLoaded(
        tasks: oldTasks + tasks,
        hasReachedMax: tasks.length < event.limit,
      ));
    } catch (error) {
      emit(TaskError(error: error.toString()));
    }
  }

  Future<void> _mapAddTaskToState(
      AddTask event, Emitter<TaskState> emit) async {
    try {
      final newTask = await taskRepository.addTask(event.task);
      final updatedTasks = List<Task>.from((state as TaskLoaded).tasks)
        ..add(newTask);
      emit(TaskLoaded(tasks: updatedTasks, hasReachedMax: false));
    } catch (error) {
      emit(TaskError(error: error.toString()));
    }
  }

  Future<void> _mapUpdateTaskToState(
      UpdateTask event, Emitter<TaskState> emit) async {
    try {
      final updatedTask = await taskRepository.updateTask(event.task);
      final updatedTasks = (state as TaskLoaded).tasks.map((task) {
        return task.id == updatedTask.id ? updatedTask : task;
      }).toList();
      emit(TaskLoaded(tasks: updatedTasks, hasReachedMax: false));
    } catch (error) {
      emit(TaskError(error: error.toString()));
    }
  }

  Future<void> _mapDeleteTaskToState(
      DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.taskId);
      final updatedTasks = (state as TaskLoaded)
          .tasks
          .where((task) => task.id != event.taskId)
          .toList();
      emit(TaskLoaded(tasks: updatedTasks, hasReachedMax: false));
    } catch (error) {
      emit(TaskError(error: error.toString()));
    }
  }
}
