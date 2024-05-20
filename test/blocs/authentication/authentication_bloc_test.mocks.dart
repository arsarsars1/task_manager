// Mocks generated by Mockito 5.4.4 from annotations
// in task_manager/test/blocs/authentication/authentication_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:task_manager/models/user_model.dart' as _i4;
import 'package:task_manager/repositories/authentication_repository.dart'
    as _i2;

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

/// A class which mocks [AuthenticationRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationRepository extends _i1.Mock
    implements _i2.AuthenticationRepository {
  MockAuthenticationRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.UserModel?> authenticate({
    required String? username,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #authenticate,
          [],
          {
            #username: username,
            #password: password,
          },
        ),
        returnValue: _i3.Future<_i4.UserModel?>.value(),
      ) as _i3.Future<_i4.UserModel?>);

  @override
  _i3.Future<void> persistUser(_i4.UserModel? user) => (super.noSuchMethod(
        Invocation.method(
          #persistUser,
          [user],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> persistToken(String? token) => (super.noSuchMethod(
        Invocation.method(
          #persistToken,
          [token],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> deleteToken() => (super.noSuchMethod(
        Invocation.method(
          #deleteToken,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<bool> isAuthenticated() => (super.noSuchMethod(
        Invocation.method(
          #isAuthenticated,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<_i4.UserModel?> getCurrentUser() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentUser,
          [],
        ),
        returnValue: _i3.Future<_i4.UserModel?>.value(),
      ) as _i3.Future<_i4.UserModel?>);
}
