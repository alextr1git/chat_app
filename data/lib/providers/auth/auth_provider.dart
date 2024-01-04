import 'package:domain/domain.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;

  Future<AuthUser> logInUser({
    required String id,
    required String password,
  });

  Future<AuthUser> createUser({
    required String id,
    required String password,
  });

  Future<void> logOutUser();
  Future<void> sendVerification();
}