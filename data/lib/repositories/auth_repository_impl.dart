import 'package:domain/repositories/repositories.dart';

import '../providers/auth/auth_provider.dart';
import 'package:domain/domain.dart';
import '../providers/auth/firebase_auth_provider.dart';
class AuthRepositoryImpl implements AuthRepository{

  final AuthProvider provider;

const AuthRepositoryImpl(this.provider);

factory AuthRepositoryImpl.firebase() => AuthRepositoryImpl(FirebaseAuthProvider());

@override
Future<AuthUser> createUser({
  required String id,
  required String password,
}) =>
    provider.createUser(
      id: id,
      password: password,
    );

@override
AuthUser? get currentUser => provider.currentUser;

@override
Future<AuthUser> logInUser({
  required String id,
  required String password,
}) =>
    provider.logInUser(
      id: id,
      password: password,
    );

@override
Future<void> logOutUser() => provider.logOutUser();

@override
Future<void> sendVerification() => provider.sendVerification();

@override
Future<void> initialize() => provider.initialize();
  }


}