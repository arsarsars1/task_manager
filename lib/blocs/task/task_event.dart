import 'package:equatable/equatable.dart';
import 'package:task_manager/models/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasks extends TaskEvent {
  final int limit;
  final int skip;

  const FetchTasks({required this.limit, required this.skip});

  @override
  List<Object?> get props => [limit, skip];
}

class AddTask extends TaskEvent {
  final Todo task;

  const AddTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Todo task;

  const UpdateTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final int taskId;

  const DeleteTask({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
