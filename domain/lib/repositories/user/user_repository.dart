import 'package:domain/domain.dart';

abstract class UserRepository {
  Future<UserModel> createUser({
    required String email,
    required String password,
    required String userName,
  });

  Future<UserModel> logInUser({
    required String email,
    required String password,
    required String userName,
  });

  Future<void> logOutUser();

  Future<void> sendVerification();

  Future<UserModel> checkUserAuthStatus();
}
