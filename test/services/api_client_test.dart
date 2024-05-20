// import 'dart:convert';
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/testing.dart';
// import 'package:task_manager/services/api_client.dart';
//
// void main() {
//   group('ApiClient', () {
//     late ApiClient apiClient;
//     late MockClient mockClient;
//
//     setUp(() {
//       mockClient = MockClient((request) async {
//         if (request.url.path == '/login') {
//           return http.Response(jsonEncode({'token': 'token'}), 200);
//         } else if (request.url.path == '/signup') {
//           return http.Response(jsonEncode({'token': 'signup_token'}), 200);
//         }
//         return http.Response('Not Found', 404);
//       });
//       apiClient = ApiClient(client: mockClient);
//     });
//
//     test('login returns token', () async {
//       final response = await apiClient.post('/login', body: {
//         'username': 'test',
//         'password': 'password',
//       });
//
//       expect(response.status, true);
//       expect(response.data?['token'], 'token');
//     });
//
//     test('non-existing endpoint returns error', () async {
//       final response = await apiClient.post('/non-existing');
//
//       expect(response.status, false);
//     });
//   });
// }
