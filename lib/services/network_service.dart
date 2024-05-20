import 'package:task_manager/models/api_model.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/api_client.dart';
import 'package:task_manager/services/task_api.dart';

class NetworkService {
  final TaskApi taskApi = TaskApi();

  Future<ApiResponseModel?> getTasks(
      {required int limit, required int pageNo}) async {
    return await taskApi.fetchTasks(limit: limit, skip: pageNo);
  }

  Future<ApiResponseModel?> createTask({required String description}) async {
    return await taskApi.createTask(description: description);
  }

  Future<ApiResponseModel?> updateTask(Task task) async {
    return await taskApi.updateTask(task);
  }

  Future<ApiResponseModel?> deleteTask({required int taskId}) async {
    return await taskApi.deleteTask(taskId);
  }

//todo
  Future<ApiResponseModel?> login({
    required String userName,
    required String password,
  }) async {
    try {
      var data = await apiClient.post("/auth/login", body: {
        "username": userName,
        "password": password,
      });
      return data;
    } catch (e) {
      return ApiResponseModel(
        status: false,
        message: "",
        data: {},
      );
    }
  }
}

final networkService = NetworkService();
