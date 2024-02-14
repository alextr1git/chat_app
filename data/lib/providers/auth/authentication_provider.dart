import 'package:data/entities/user/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationProvider {
  UserEntity? getCurrentUserEntity();
  User? getCurrentUser();

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
