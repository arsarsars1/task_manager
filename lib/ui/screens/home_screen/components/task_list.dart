import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/models/task_model.dart';

class TaskList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Todo> tasks;
  final bool hasReachedMax;

  const TaskList(
      {super.key,
      required this.scrollController,
      required this.tasks,
      required this.hasReachedMax});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: hasReachedMax ? tasks.length : tasks.length + 1,
      itemBuilder: (context, index) {
        if (index >= tasks.length) {
          return const SizedBox();
        }
        final task = tasks[index];
        return ListTile(
          onTap: () {
            final updatedTask = Todo(
              id: task.id,
              todo: task.todo,
              completed: !task.completed,
              userId: task.userId,
            );
            BlocProvider.of<TaskBloc>(context)
                .add(UpdateTask(task: updatedTask));
          },
          title: Text(task.todo),
          trailing: Checkbox(
            value: task.completed,
            onChanged: (bool? value) {
              final updatedTask = Todo(
                id: task.id,
                todo: task.todo,
                completed: value ?? false,
                userId: task.userId,
              );
              BlocProvider.of<TaskBloc>(context)
                  .add(UpdateTask(task: updatedTask));
            },
          ),
          onLongPress: () {
            _showDeleteConfirmationDialog(context, task.id);
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int taskId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<TaskBloc>(context)
                    .add(DeleteTask(taskId: taskId));
                Navigator.of(ctx).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
