import 'package:data/';

abstract class AuthRepository {
  final AuthProvider provider;

  AuthUser? get currentUser => provider.currentUser;

  Future<AuthUser> createUser({
    required String id,
    required String password,
  });

  Future<AuthUser> logInUser({
    required String id,
    required String password,
  });

  Future<void> logOutUser();

  Future<void> sendVerification();

  Future<void> initialize();
}
