import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/services/authentication_service.dart';

class AuthenticationRepository {
  final AuthenticationService _authenticationService;

  AuthenticationRepository(this._authenticationService);

  Future<UserModel?> authenticate(
      {required String username, required String password}) async {
    return await _authenticationService.authenticate(username, password);
  }

  Future<void> persistUser(UserModel user) async {
    return await _authenticationService.persistUser(userModelToJson(user));
  }

  Future<void> persistToken(String token) async {
    return await _authenticationService.persistToken(token);
  }

  Future<void> deleteToken() async {
    return await _authenticationService.deleteToken();
  }

  Future<bool> isAuthenticated() async {
    return await _authenticationService.isAuthenticated();
  }

  Future<UserModel?> getCurrentUser() async {
    return await _authenticationService.getCurrentUser();
  }
}
