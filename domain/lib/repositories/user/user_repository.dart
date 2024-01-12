import 'package:domain/domain.dart';

abstract class UserRepository {
  Future<UserModel> createUser({
    required String email,
    required String password,
  });

  Future<UserModel> logInUser({
    required String email,
    required String password,
  });

  Future<void> logOutUser();

  Future<void> sendVerification();

  Future<UserModel> checkUserAuthStatus();

  Future<void> setUsername(String username);
  Future<void> setUserPhoto(String photoURL);

  UserModel? get currentUser;
}
