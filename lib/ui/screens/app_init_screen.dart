import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_state.dart';
import 'package:task_manager/ui/screens/home_screen/home_screen.dart';
import 'package:task_manager/ui/screens/loading_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';

class AppInit extends StatelessWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
