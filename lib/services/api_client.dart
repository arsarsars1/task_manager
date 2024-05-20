import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:task_manager/core/network/endpoints.dart';
import 'package:task_manager/models/api_model.dart';

class ApiClient {
  final Map<String, String> baseHeadersBody = {
    "Content-Type": "application/json",
    'x-api-key': "secret",
    "Accept": "*/*",
  };
  final Map<String, String> baseHeadersForm = {
    "Accept": "*/*",
    'x-api-key': "secret",
    'Accept-Charset': 'utf-8',
  };

  Future<ApiResponseModel> get(
    String pathUrl, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathVariables,
  }) async {
    String url = buildUrl(pathUrl,
        pathVariables: pathVariables, queryParameters: queryParameters);
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

  Future<ApiResponseModel> post(
    String pathUrl, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathVariables,
    Map<String, dynamic>? body,
  }) async {
    String url = buildUrl(pathUrl,
        pathVariables: pathVariables, queryParameters: queryParameters);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: baseHeadersBody,
        body: body != null ? jsonEncode(body) : null,
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

  Future<ApiResponseModel> delete(
    String pathUrl, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathVariables,
  }) async {
    String url = buildUrl(pathUrl,
        pathVariables: pathVariables, queryParameters: queryParameters);
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
    Map<String, dynamic>? pathVariables,
    Map<String, dynamic>? queryParameters,
    bool? disableBuiltInUrl,
  }) {
    String url =
        disableBuiltInUrl == true ? endpoint : Endpoints.baseURL + endpoint;

    // Add path variables
    if (pathVariables != null && pathVariables.isNotEmpty) {
      url += '/${_encodePathVariables(pathVariables)}';
    }

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

  String _encodePathVariables(Map<String, dynamic> pathVariables) {
    return pathVariables.entries
        .map((e) => Uri.encodeComponent(e.value.toString()))
        .join('/');
  }
}

final apiClient = ApiClient();
