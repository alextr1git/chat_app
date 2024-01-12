import 'package:data/entities/user/user_entity.dart';
import 'package:domain/domain.dart';

abstract class AuthenticationProvider {
  UserEntity? get currentUser;

  Future<UserEntity> logInUser({
    required String email,
    required String password,
  });

  Future<UserEntity> createUser({
    required String email,
    required String password,
  });

  Future<void> logOutUser();
  Future<void> sendVerification();
  Future<UserEntity> checkUserAuthStatus();

  Future<void> setUsername(String username);
  Future<void> setUserPhoto(String photoURL);
}
