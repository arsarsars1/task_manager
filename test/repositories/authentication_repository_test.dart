import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/repositories/authentication_repository.dart';
import 'package:task_manager/services/authentication_service.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

void main() {
  group('AuthenticationRepository', () {
    late AuthenticationRepository authenticationRepository;
    late MockAuthenticationService mockAuthenticationService;

    setUp(() {
      mockAuthenticationService = MockAuthenticationService();
      authenticationRepository =
          AuthenticationRepository(mockAuthenticationService);
    });

    test('getCurrentUser returns current user from shared preferences',
        () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":1,"username":"kminchelle","email":"kminchelle@example.com","firstName":"Test","lastName":"User","gender":"male","image":"image.png","token":"token"}'
      });
      final user = await authenticationRepository.getCurrentUser();
      expect(user, isNotNull);
      expect(user?.username, 'test');
    });

    test('logIn logs in the user and saves to shared preferences', () async {
      final user = UserModel(
        id: 1,
        username: 'kminchelle',
        email: 'kminchelle@example.com',
        firstName: 'Test',
        lastName: 'User',
        gender: 'male',
        image: 'image.png',
        token: 'token',
      );
      when(mockAuthenticationService.authenticate('kminchelle', '0lelplR'))
          .thenAnswer((_) async => user);

      final loggedInUser = await authenticationRepository.authenticate(
          username: 'kminchelle', password: '0lelplR');
      expect(loggedInUser, isNotNull);
      expect(loggedInUser?.username, 'test');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user'), isNotNull);
    });

    test('logOut logs out the user and clears shared preferences', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":1,"username":"kminchelle","email":"kminchelle@example.com","firstName":"Test","lastName":"User","gender":"male","image":"image.png","token":"token"}'
      });
      await authenticationRepository.deleteToken();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user'), isNull);
    });
  });
}
