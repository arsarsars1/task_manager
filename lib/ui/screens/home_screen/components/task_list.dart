import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/blocs/task/task_state.dart';
import 'package:task_manager/models/task_model.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return ListTile(
                title: Text(task.todo),
                trailing: Checkbox(
                  value: task.completed,
                  onChanged: (bool? value) {
                    final updatedTask = Task(
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
        } else if (state is TaskError) {
          return const Center(child: Text('Failed to load tasks'));
        } else {
          return Container();
        }
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
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<TaskBloc>(context)
                    .add(DeleteTask(taskId: taskId));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
