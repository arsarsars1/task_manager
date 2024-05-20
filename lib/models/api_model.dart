class ApiResponseModel {
  bool status;
  int? statusCode;
  String? message;
  Map<String, dynamic>? data;
  ApiResponseModel({
    required this.status,
    this.statusCode,
    required this.message,
    this.data,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      status: json['status'] ?? false,
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'],
    );
  }

  @override
  String toString() {
    return {
      "status": status,
      "statusCode": statusCode,
      "message": message,
      "data": data
    }.toString();
  }
}
