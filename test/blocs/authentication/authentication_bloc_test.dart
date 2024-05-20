import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_event.dart';
import 'package:task_manager/blocs/authentication/authentication_state.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/repositories/authentication_repository.dart';
import 'package:test/test.dart';

// Generate a MockAuthenticationRepository using Mockito
@GenerateMocks([AuthenticationRepository])
import 'authentication_bloc_test.mocks.dart';

void main() {
  group('AuthenticationBloc', () {
    late AuthenticationBloc authenticationBloc;
    late MockAuthenticationRepository mockAuthenticationRepository;

    setUp(() {
      mockAuthenticationRepository = MockAuthenticationRepository();
      authenticationBloc = AuthenticationBloc(mockAuthenticationRepository);
    });

    tearDown(() {
      authenticationBloc.close();
    });

    test('initial state is AuthenticationUninitialized', () {
      expect(authenticationBloc.state, AuthenticationUninitialized());
    });

    final user = UserModel(
      id: 1,
      username: 'test',
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      gender: 'male',
      image: 'image.png',
      token: 'token',
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationLoading, AuthenticationAuthenticated] when AppStarted is added and user is authenticated',
      build: () {
        when(mockAuthenticationRepository.isAuthenticated())
            .thenAnswer((_) async => true);
        when(mockAuthenticationRepository.getCurrentUser())
            .thenAnswer((_) async => user);
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [
        AuthenticationLoading(),
        AuthenticationAuthenticated(user: user),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationLoading, AuthenticationUnauthenticated] when AppStarted is added and user is not authenticated',
      build: () {
        when(mockAuthenticationRepository.isAuthenticated())
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
      build: () {
        when(mockAuthenticationRepository.authenticate(
                username: 'test', password: 'password'))
            .thenAnswer((_) async => user);
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(LoggedIn(username: 'test', password: 'password')),
      expect: () => [
        AuthenticationLoading(),
        AuthenticationAuthenticated(user: user),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationLoading, AuthenticationUnauthenticated] when LoggedOut is added',
      build: () {
        when(mockAuthenticationRepository.deleteToken())
            .thenAnswer((_) async => Future.value(null));
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(LoggedOut()),
      expect: () => [
        AuthenticationLoading(),
        AuthenticationUnauthenticated(),
      ],
    );
  });
}
