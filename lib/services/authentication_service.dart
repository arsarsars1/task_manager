import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/network/endpoints.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/services/api_client.dart';

class AuthenticationService {
  final ApiClient _apiClient;
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_info';

  AuthenticationService(this._apiClient);

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString(userKey);
    final token = prefs.getString(tokenKey);
    return token != null && user != null;
  }

  Future<void> persistUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, user);
  }

  Future<void> persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    await prefs.remove(tokenKey);
  }

  Future<UserModel?> authenticate(String username, String password) async {
    var response = await _apiClient.post(Endpoints.login, body: {
      "username": username,
      "password": password,
    });
    if ((response.status ?? false) && response.data != null) {
      return UserModel.fromJson(response.data!);
    } else {
      throw Exception(response.message);
    }
  }
}
