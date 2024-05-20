import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_event.dart';
import 'package:task_manager/blocs/authentication/authentication_state.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/repositories/authentication_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:task_manager/services/api_client.dart';
import 'package:task_manager/services/authentication_service.dart';
import 'package:task_manager/services/connectivity_cubit.dart';
import 'package:task_manager/services/connectivity_service.dart';
import 'package:task_manager/services/network_service.dart';
import 'package:task_manager/ui/screens/home_screen/home_screen.dart';
import 'package:task_manager/ui/screens/loading_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';

void main() {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(AuthenticationService(ApiClient()));

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
              ),
            )..add(const FetchTasks(limit: 20, skip: 0)), // Initialize here
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
  final ConnectivityService connectivityService = ConnectivityService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppInit(connectivityService: connectivityService),
    );
  }
}

class AppInit extends StatelessWidget {
  final ConnectivityService connectivityService;

  const AppInit({super.key, required this.connectivityService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: connectivityService.isConnected(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && !snapshot.data!) {
          return const Scaffold(
            body: Center(
              child: Text('No internet connection. You are offline.'),
            ),
          );
        }

        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUninitialized) {
              return const SplashScreen();
            } else if (state is AuthenticationLoading) {
              return const LoadingScreen();
            } else if (state is AuthenticationAuthenticated) {
              return const HomeScreen();
            } else if (state is AuthenticationUnauthenticated) {
              return LoginScreen();
            }
            return Container();
          },
        );
      },
    );
  }
}
