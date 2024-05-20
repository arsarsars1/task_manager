// test/repositories/authentication_repository_test.dart
import 'package:task_manager/repositories/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_authentication_service.dart';

void main() {
  late AuthenticationRepository authenticationRepository;
  late MockAuthenticationService mockAuthenticationService;

  setUp(() {
    mockAuthenticationService = MockAuthenticationService();
    authenticationRepository =
        AuthenticationRepository(mockAuthenticationService);
  });

  test('should return true if service returns true', () async {
    when(() => mockAuthenticationService.isAuthenticated())
        .thenAnswer((_) async => true);

    final result = await authenticationRepository.isAuthenticated();
    expect(result, true);
  });

  test('should return false if service returns false', () async {
    when(() => mockAuthenticationService.isAuthenticated())
        .thenAnswer((_) async => false);

    final result = await authenticationRepository.isAuthenticated();
    expect(result, false);
  });

  test('should call persistToken on service', () async {
    const token = 'test_token';

    await authenticationRepository.persistToken(token);
    verify(() => mockAuthenticationService.persistToken(token)).called(1);
  });

  test('should call deleteToken on service', () async {
    await authenticationRepository.deleteToken();
    verify(() => mockAuthenticationService.deleteToken()).called(1);
  });
}
