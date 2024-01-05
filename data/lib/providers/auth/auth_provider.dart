import 'package:data/entities/user/user_entity.dart';
import 'package:domain/domain.dart';

abstract class AuthProvider {
  Future<void> initialize();
  UserEntity? get currentUser;

  Future<UserEntity> logInUser({
    required String email,
    required String password,
    required String userName,
  });

  Future<UserEntity> createUser({
    required String email,
    required String password,
    required String userName,
  });

  Future<void> logOutUser();
  Future<void> sendVerification();
}
