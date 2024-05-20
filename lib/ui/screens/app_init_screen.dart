import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_state.dart';
import 'package:task_manager/services/connectivity_service.dart';
import 'package:task_manager/ui/screens/home_screen/home_screen.dart';
import 'package:task_manager/ui/screens/loading_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';

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
