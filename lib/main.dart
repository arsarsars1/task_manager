import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_event.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/cubits/connectivity_cubit.dart';
import 'package:task_manager/repositories/authentication_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:task_manager/services/authentication_service.dart';
import 'package:task_manager/services/connectivity_service.dart';
import 'package:task_manager/services/navigation_service.dart';
import 'package:task_manager/services/network_service.dart';
import 'package:task_manager/ui/screens/app_init_screen.dart';

void main() {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(AuthenticationService(NetworkService()));

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => authenticationRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(authenticationRepository)..add(AppStarted()),
          ),
          BlocProvider<TaskBloc>(
            create: (context) => TaskBloc(
              taskRepository: TaskRepository(
                networkService: NetworkService(),
                connectivityService: ConnectivityService(),
              ),
            )..add(const FetchTasks(limit: 20, skip: 0)),
          ),
          BlocProvider<ConnectivityCubit>(
            create: (context) =>
                ConnectivityCubit(Connectivity())..checkConnectivity(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppInit(),
    );
  }
}
