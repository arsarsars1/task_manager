import 'package:bloc/bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/blocs/task/task_state.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/repositories/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<FetchTasks>(_onFetchTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onFetchTasks(FetchTasks event, Emitter<TaskState> emit) async {
    final currentState = state;
    var oldTasks = <Task>[];
    if (currentState is TaskLoaded) {
      oldTasks = currentState.tasks;
    }

    try {
      emit(TaskLoading());
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

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      final currentState = state;
      if (currentState is TaskLoaded) {
        emit(TaskUpdating());
        final newTask = await taskRepository.addTask(event.task);
        final updatedTasks = List<Task>.from(currentState.tasks)..add(newTask);
        emit(TaskLoaded(tasks: updatedTasks, hasReachedMax: false));
      } else {
        emit(const TaskError(error: 'Failed to add task'));
      }
    } catch (error) {
      emit(TaskError(error: error.toString()));
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
        emit(TaskLoaded(tasks: updatedTasks, hasReachedMax: false));
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
        emit(TaskLoaded(tasks: updatedTasks, hasReachedMax: false));
      } catch (error) {
        emit(TaskError(error: error.toString()));
      }
    } else {
      emit(const TaskError(error: 'Failed to delete task'));
    }
  }
}
