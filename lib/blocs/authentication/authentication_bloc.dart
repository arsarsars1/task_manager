import 'package:bloc/bloc.dart';
import 'package:task_manager/repositories/authentication_repository.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationUninitialized()) {
    on<AppStarted>(_mapEventToState);
    on<LoggedIn>(_mapEventToState);
    on<LoggedOut>(_mapEventToState);
  }

  Future<void> _mapEventToState(
      AuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    if (event is AppStarted) {
      emit(AuthenticationLoading());
      final bool isAuthenticated =
          await _authenticationRepository.isAuthenticated();
      if (isAuthenticated) {
        final user = await _authenticationRepository.getCurrentUser();
        if (user != null) {
          emit(AuthenticationAuthenticated(user: user));
        } else {
          emit(AuthenticationUnauthenticated());
        }
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } else if (event is LoggedIn) {
      emit(AuthenticationLoading());
      final user = await _authenticationRepository.authenticate(
          username: event.username, password: event.password);
      if (user != null) {
        await _authenticationRepository.persistUser(user);
        await _authenticationRepository.persistToken(user.token);
        emit(AuthenticationAuthenticated(user: user));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } else if (event is LoggedOut) {
      emit(AuthenticationLoading());
      await _authenticationRepository.deleteToken();
      emit(AuthenticationUnauthenticated());
    }
  }
}
