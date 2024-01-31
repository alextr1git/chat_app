import 'package:data/entities/user/user_entity.dart';

abstract class AuthenticationProvider {
  UserEntity? get currentUser;

  Future<UserEntity> createUser({
    required String email,
    required String password,
  });

  Future<UserEntity> logInUser({
    required String email,
    required String password,
  });
  Future<void> logOutUser();

  Future<UserEntity> checkUserAuthStatus();

  Future<void> sendVerification();
  Future<void> setUsername(String username);
  Future<void> setUserPhoto(String photoURL);
}
