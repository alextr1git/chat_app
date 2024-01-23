import 'dart:io';

import 'package:domain/domain.dart';

abstract class UserRepository {
  Future<UserModel> createUser({
    required String username,
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
  Future<String> getUsernameByID(String userID);
  Future<void> updateUsername(String username);
  Future<void> setUserPhoto(String photoURL);
  Future<void> uploadImage(File image);
  Future<String> downloadImage();

  UserModel? get currentUser;
}
