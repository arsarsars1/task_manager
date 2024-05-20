// Mocks generated by Mockito 5.4.4 from annotations
// in task_manager/test/repositories/task_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:task_manager/models/api_model.dart' as _i2;
import 'package:task_manager/models/task_model.dart' as _i5;
import 'package:task_manager/services/network_service.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeApiResponseModel_0 extends _i1.SmartFake
    implements _i2.ApiResponseModel {
  _FakeApiResponseModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [NetworkService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkService extends _i1.Mock implements _i3.NetworkService {
  MockNetworkService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, String> get baseHeadersBody => (super.noSuchMethod(
        Invocation.getter(#baseHeadersBody),
        returnValue: <String, String>{},
      ) as Map<String, String>);

  @override
  _i4.Future<Map<String, dynamic>?> getTasks({
    required int? skip,
    int? limit = 10,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTasks,
          [],
          {
            #skip: skip,
            #limit: limit,
          },
        ),
        returnValue: _i4.Future<Map<String, dynamic>?>.value(),
      ) as _i4.Future<Map<String, dynamic>?>);

  @override
  _i4.Future<Map<String, dynamic>?> createTask(
          {required String? description}) =>
      (super.noSuchMethod(
        Invocation.method(
          #createTask,
          [],
          {#description: description},
        ),
        returnValue: _i4.Future<Map<String, dynamic>?>.value(),
      ) as _i4.Future<Map<String, dynamic>?>);

  @override
  _i4.Future<Map<String, dynamic>?> updateTask(_i5.Todo? task) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateTask,
          [task],
        ),
        returnValue: _i4.Future<Map<String, dynamic>?>.value(),
      ) as _i4.Future<Map<String, dynamic>?>);

  @override
  _i4.Future<Map<String, dynamic>?> deleteTask({required int? taskId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteTask,
          [],
          {#taskId: taskId},
        ),
        returnValue: _i4.Future<Map<String, dynamic>?>.value(),
      ) as _i4.Future<Map<String, dynamic>?>);

  @override
  _i4.Future<_i2.ApiResponseModel> post(
    String? pathUrl, {
    Map<String, dynamic>? body,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [pathUrl],
          {#body: body},
        ),
        returnValue:
            _i4.Future<_i2.ApiResponseModel>.value(_FakeApiResponseModel_0(
          this,
          Invocation.method(
            #post,
            [pathUrl],
            {#body: body},
          ),
        )),
      ) as _i4.Future<_i2.ApiResponseModel>);
}
