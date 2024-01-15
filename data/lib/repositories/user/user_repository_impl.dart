import 'dart:io';

import 'package:data/data.dart';
import 'package:data/providers/storage/storage_provider.dart';
import '../../providers/auth/authentication_provider.dart';
import 'package:domain/domain.dart';
import '../../providers/auth/firebase_auth_provider.dart';

class UserAuthRepositoryImpl implements UserRepository {
  final AuthenticationProvider _authProvider;
  final StorageProvider _storageProvider;

  const UserAuthRepositoryImpl({
    required AuthenticationProvider authProvider,
    required StorageProvider storageProvider,
  })  : _storageProvider = storageProvider,
        _authProvider = authProvider;

  @override
  Future<UserModel> createUser({
    required String email,
    required String password,
  }) async {
    UserEntity userEntity = await _authProvider.createUser(
      email: email,
      password: password,
    );
    return UserMapper.toModel(userEntity);
  }

  @override
  UserModel? get currentUser => (_authProvider.currentUser != null)
      ? UserMapper.toModel(_authProvider.currentUser!)
      : null;

  @override
  Future<UserModel> logInUser({
    required String email,
    required String password,
  }) async {
    await _authProvider.logInUser(
      email: email,
      password: password,
    );
    UserModel userModel = currentUser!;
    return userModel;
  }

  @override
  Future<void> logOutUser() => _authProvider.logOutUser();

  @override
  Future<void> sendVerification() => _authProvider.sendVerification();

  @override
  Future<UserModel> checkUserAuthStatus() async {
    UserEntity userEntity = await _authProvider.checkUserAuthStatus();
    return UserMapper.toModel(userEntity);
  }

  @override
  Future<void> setUserPhoto(String photoURL) async {
    await _authProvider.setUserPhoto(photoURL);
  }

  @override
  Future<void> setUsername(String username) async {
    await _authProvider.setUsername(username);
  }

  @override
  Future<void> uploadImage(File image) async {
    final String? photoURL = await _storageProvider.uploadImage(
      image: image,
      userId: currentUser!.id.toString(),
    );
    if (photoURL != null) {
      _authProvider.setUserPhoto(photoURL);
    }
  }

  @override
  Future<String> downloadImage() async {
    return await _storageProvider.downloadImage(
      userId: currentUser!.id.toString(),
    );
  }
}
