// test/blocs/authentication_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_event.dart';
import 'package:task_manager/blocs/authentication/authentication_state.dart';
import 'package:task_manager/repositories/authentication_repository.dart';

import '../mocks/mock_authentication_service.dart';

void main() {
  late AuthenticationRepository authenticationRepository;
  late MockAuthenticationService mockAuthenticationService;
  late AuthenticationBloc authenticationBloc;

  setUp(() {
    mockAuthenticationService = MockAuthenticationService();
    authenticationRepository =
        AuthenticationRepository(mockAuthenticationService);
    authenticationBloc = AuthenticationBloc(authenticationRepository);
  });

  tearDown(() {
    authenticationBloc.close();
  });

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [AuthenticationLoading, AuthenticationAuthenticated] when AppStarted and user is authenticated',
    build: () {
      when(() => authenticationRepository.isAuthenticated())
          .thenAnswer((_) async => true);
      return authenticationBloc;
    },
    act: (bloc) => bloc.add(AppStarted()),
    expect: () => [
      AuthenticationLoading(),
      AuthenticationAuthenticated(),
    ],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [AuthenticationLoading, AuthenticationUnauthenticated] when AppStarted and user is not authenticated',
    build: () {
      when(() => authenticationRepository.isAuthenticated())
          .thenAnswer((_) async => false);
      return authenticationBloc;
    },
    act: (bloc) => bloc.add(AppStarted()),
    expect: () => [
      AuthenticationLoading(),
      AuthenticationUnauthenticated(),
    ],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [AuthenticationLoading, AuthenticationAuthenticated] when LoggedIn is added',
    build: () => authenticationBloc,
    act: (bloc) => bloc.add(const LoggedIn(token: 'test_token')),
    expect: () => [
      AuthenticationLoading(),
      AuthenticationAuthenticated(),
    ],
    verify: (_) {
      verify(() => authenticationRepository.persistToken('test_token'))
          .called(1);
    },
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    'emits [AuthenticationLoading, AuthenticationUnauthenticated] when LoggedOut is added',
    build: () => authenticationBloc,
    act: (bloc) => bloc.add(LoggedOut()),
    expect: () => [
      AuthenticationLoading(),
      AuthenticationUnauthenticated(),
    ],
    verify: (_) {
      verify(() => authenticationRepository.deleteToken()).called(1);
    },
  );
}
