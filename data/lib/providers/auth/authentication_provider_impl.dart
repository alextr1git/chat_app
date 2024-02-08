import 'package:data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProviderImpl implements AuthenticationProvider {
  final FirebaseAuth _firebaseAuth;

  AuthenticationProviderImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  UserEntity? getCurrentUserEntity() {
    final User? firebaseUser = _firebaseAuth.currentUser;
    return (firebaseUser != null)
        ? UserEntity.fromFirebase(firebaseUser)
        : null;
  }

  @override
  User? getCurrentUser() {
    final User? firebaseUser = _firebaseAuth.currentUser;
    return (firebaseUser != null) ? firebaseUser : null;
  }

  @override
  Future<UserEntity> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final UserEntity? userEntity = getCurrentUserEntity();
      if (userEntity != null) {
        return userEntity;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'network-request-failed') {
        throw NetworkRequestFailedAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<UserEntity> logInUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final UserEntity? userEntity = getCurrentUserEntity();
      if (userEntity != null) {
        return userEntity;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw InvalidCredentialsAuthException();
      } else if (e.code == 'network-request-failed') {
        throw NetworkRequestFailedAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOutUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<UserEntity> checkUserAuthStatus() async {
    final UserEntity? userEntity = getCurrentUserEntity();
    if (userEntity != null) {
      return userEntity;
    } else {
      return UserEntity.empty;
    }
  }

  @override
  Future<void> sendVerification() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> setUserPhoto(String photoURL) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      user.updatePhotoURL(photoURL);
    }
  }

  @override
  Future<void> setUsername(String username) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      user.updateDisplayName(username);
    }
  }
}
