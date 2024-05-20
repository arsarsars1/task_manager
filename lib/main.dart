import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_event.dart';
import 'package:task_manager/blocs/authentication/authentication_state.dart';
import 'package:task_manager/repositories/authentication_repository.dart';
import 'package:task_manager/services/api_client.dart';
import 'package:task_manager/services/authentication_service.dart';
import 'package:task_manager/services/navigation_service.dart';
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
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      navigatorKey: NavigationService.navigatorKey,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
      ),
    );
  }
}
