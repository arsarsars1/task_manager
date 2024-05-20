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
  final List<Task> tasks;
  final bool hasReachedMax;

  const TaskLoaded({required this.tasks, required this.hasReachedMax});

  @override
  List<Object> get props => [tasks, hasReachedMax];
}

class TaskError extends TaskState {
  final String error;

  const TaskError({required this.error});

  @override
  List<Object> get props => [error];
}
