import 'package:bloc/bloc.dart';
import 'package:task_manager/repositories/authentication_repository.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationUninitialized()) {
    on<AppStarted>(mapEventToState);
    on<LoggedIn>(mapEventToState);
    on<LoggedOut>(mapEventToState);
  }

  mapEventToState(
      AuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    if (event is AppStarted) {
      emit(AuthenticationLoading());
      final bool isAuthenticated =
          await _authenticationRepository.isAuthenticated();
      if (isAuthenticated) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    }

    if (event is LoggedIn) {
      emit(AuthenticationLoading());
      await _authenticationRepository.persistToken(event.token);
      emit(AuthenticationAuthenticated());
    }

    if (event is LoggedOut) {
      emit(AuthenticationLoading());
      await _authenticationRepository.deleteToken();
      emit(AuthenticationUnauthenticated());
    }
  }
}
