import 'package:equatable/equatable.dart';
import 'package:task_manager/models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Todo> tasks;
  final bool hasReachedMax;
  final bool isBottomLoading;

  const TaskLoaded({
    required this.tasks,
    required this.hasReachedMax,
    this.isBottomLoading = false,
  });

  TaskLoaded copyWith({
    List<Todo>? tasks,
    bool? hasReachedMax,
    bool? isBottomLoading,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isBottomLoading: isBottomLoading ?? this.isBottomLoading,
    );
  }

  @override
  List<Object> get props => [tasks, hasReachedMax, isBottomLoading];
}

class TaskUpdating extends TaskState {}

class TaskDeleting extends TaskState {}

class TaskError extends TaskState {
  final String error;

  const TaskError({required this.error});

  @override
  List<Object> get props => [error];
}
