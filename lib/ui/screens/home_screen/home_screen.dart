import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_event.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/blocs/task/task_state.dart';
import 'package:task_manager/cubits/connectivity_cubit.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/ui/screens/home_screen/components/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final int _limit = 20;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchTasks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchTasks() {
    context.read<TaskBloc>().add(FetchTasks(limit: _limit, skip: _skip));
  }

  void _onScroll() {
    if (_isBottom && !context.read<TaskBloc>().isFetching) {
      final currentState = context.read<TaskBloc>().state;
      if (currentState is TaskLoaded && !currentState.hasReachedMax) {
        _skip += _limit;
        _fetchTasks();
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddTaskDialog(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
                builder: (context, state) {
                  if (state == ConnectivityStatus.disconnected) {
                    return Container(
                      color: Colors.red,
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(
                        child: Text(
                          'No internet connection. You are offline.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoaded) {
                      if (state.tasks.isEmpty) {
                        return const Center(child: Text('No tasks available.'));
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: TaskList(
                              scrollController: _scrollController,
                              tasks: state.tasks,
                              hasReachedMax: state.hasReachedMax,
                            ),
                          ),
                          if (state.isBottomLoading)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      );
                    } else if (state is TaskError) {
                      return Center(child: Text(state.error));
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskUpdating || state is TaskDeleting) {
                return Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: taskController,
            decoration:
                const InputDecoration(hintText: 'Enter task description'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final task = Todo(
                  id: DateTime.now().millisecondsSinceEpoch,
                  todo: taskController.text,
                  completed: false,
                  userId: 1,
                );
                BlocProvider.of<TaskBloc>(context).add(AddTask(task: task));
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
