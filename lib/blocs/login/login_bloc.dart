import 'package:bloc/bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/authentication/authentication_event.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/repositories/authentication_repository.dart';
import 'package:task_manager/utils/constants.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;
  final AuthenticationRepository authenticationRepository;

  LoginBloc(
      {required this.authenticationRepository,
      required this.authenticationBloc})
      : super(LoginInitial()) {
    on<LoginButtonPressed>(mapEventToState);
  }

  mapEventToState(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginButtonPressed) {
      emit(LoginLoading());

      try {
        UserModel? response = await authenticationRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        if (response != null) {
          Constant.showMessage("Login successfully");
          await authenticationRepository.persistUser(userModelToJson(response));
          await authenticationRepository.persistToken(response.token);
          authenticationBloc.add(LoggedIn(token: response.token));
          emit(LoginInitial());
        } else {
          Constant.showMessage(
            "Unable to complete process, please try again",
          );
        }
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    }
  }
}
