import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/network/endpoints.dart';
import 'package:task_manager/models/api_model.dart';
import 'package:task_manager/models/task_model.dart';

class NetworkService {
  final Map<String, String> baseHeadersBody = {
    "Content-Type": "application/json",
    // "Accept": "*/*",
  };
  Future<Map<String, dynamic>?> getTasks(
      {required int skip, int limit = 10}) async {
    final response =
        await http.get(Uri.parse('${Endpoints.todos}?limit=$limit&skip=$skip'));
    if (response.statusCode == 200) {
      debugPrint(response.request!.url.toString());
      debugPrint(response.body);
      return json.decode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> createTask(
      {required String description}) async {
    final response = await http.post(
      Uri.parse(Endpoints.todoAdd),
      headers: baseHeadersBody,
      body: jsonEncode({"todo": description, "completed": false, "userId": 1}),
    );
    if (response.statusCode == 200) {
      debugPrint(response.request!.url.toString());
      debugPrint(response.body);
      return json.decode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateTask(Todo task) async {
    final response = await http.put(
      Uri.parse('${Endpoints.todos}/${task.id}'),
      headers: baseHeadersBody,
      body: jsonEncode(task.toApiJson()),
    );
    if (response.statusCode == 200) {
      debugPrint(response.request!.url.toString());
      debugPrint(response.body);
      return json.decode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> deleteTask({required int taskId}) async {
    final response = await http.delete(Uri.parse('${Endpoints.todos}/$taskId'));
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return json.decode(response.body);
    }
    return null;
  }

  Future<ApiResponseModel> post(String pathUrl,
      {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.login),
        headers: baseHeadersBody,
        body: body != null ? jsonEncode(body) : null,
      );
      return ApiResponseModel.fromJson({
        "status": true,
        "message": "success",
        "statusCode": response.statusCode,
        "data": json.decode(response.body),
      });
    } catch (e) {
      log(e.toString());
      return ApiResponseModel(
        status: false,
        message: e.toString(),
        data: {},
      );
    }
  }
}
