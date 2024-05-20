import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:task_manager/core/network/endpoints.dart';
import 'package:task_manager/models/api_model.dart';
import 'package:task_manager/models/task_model.dart';

class TaskApi {
  final Map<String, String> baseHeadersBody = {
    "Content-Type": "application/json",
    'x-api-key': "secret",
    "Accept": "*/*",
  };

  Future<ApiResponseModel> fetchTasks({int limit = 10, int skip = 0}) async {
    String url = buildUrl(Endpoints.todos,
        queryParameters: {"limit": limit, "skip": skip});
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: baseHeadersBody,
      );
      return handleResponse(response, url);
    } catch (e) {
      log(e.toString());
      return ApiResponseModel(
        status: false,
        message: e.toString(),
        data: {},
      );
    }
  }

  Future<ApiResponseModel> createTask({required String description}) async {
    String url = buildUrl(Endpoints.todoAdd);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: baseHeadersBody,
        body:
            jsonEncode({"todo": description, "completed": false, "userId": 1}),
      );
      return handleResponse(response, url);
    } catch (e) {
      log(e.toString());
      return ApiResponseModel(
        status: false,
        message: e.toString(),
        data: {},
      );
    }
  }

  Future<ApiResponseModel> updateTask(Task task) async {
    String url = buildUrl("${Endpoints.todos}/${task.id}");
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: baseHeadersBody,
        body: jsonEncode(task.toApiJson()),
      );
      return handleResponse(response, url);
    } catch (e) {
      log(e.toString());
      return ApiResponseModel(
        status: false,
        message: e.toString(),
        data: {},
      );
    }
  }

  Future<ApiResponseModel> deleteTask(int taskId) async {
    String url = buildUrl("${Endpoints.todos}/$taskId");
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: baseHeadersBody,
      );
      return handleResponse(response, url);
    } catch (e) {
      log(e.toString());
      return ApiResponseModel(
        status: false,
        message: e.toString(),
        data: {},
      );
    }
  }

  ApiResponseModel handleResponse(http.Response response, String url) {
    try {
      var data = json.decode(response.body);
      log("response: $data, time:${DateTime.now()} endPoint: $url");
      if (response.statusCode == 200) {
        return ApiResponseModel.fromJson({
          "status": true,
          "message": "success",
          "statusCode": 200,
          "data": data
        });
      } else {
        return ApiResponseModel(
          status: false,
          message: data["message"],
          data: {},
        );
      }
    } catch (e) {
      log(e.toString());
      return ApiResponseModel(
        status: false,
        message: e.toString(),
        data: {},
      );
    }
  }

  String buildUrl(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) {
    String url = Endpoints.baseURL + endpoint;

    // Add query parameters
    if (queryParameters != null && queryParameters.isNotEmpty) {
      url = _addQueryParameters(url, queryParameters);
    }

    return url;
  }

  String _addQueryParameters(String url, Map<String, dynamic> queryParameters) {
    String queryString = _encodeQueryParameters(queryParameters);
    return url.contains('?') ? '$url&$queryString' : '$url?$queryString';
  }

  String _encodeQueryParameters(Map<String, dynamic> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }
}
