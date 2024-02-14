import 'dart:io';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

class UserAuthRepositoryImpl implements UserRepository {
  final AuthenticationProvider _authProvider;
  final StorageProvider _storageProvider;
  final RealTimeDatabaseProvider _databaseProvider;

  const UserAuthRepositoryImpl({
    required AuthenticationProvider authProvider,
    required StorageProvider storageProvider,
    required RealTimeDatabaseProvider databaseProvider,
  })  : _storageProvider = storageProvider,
        _authProvider = authProvider,
        _databaseProvider = databaseProvider;

  @override
  Future<UserModel> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    UserEntity userEntity = await _authProvider.createUser(
      email: email,
      password: password,
    );
    _databaseProvider.updateUsernameData(userEntity.id, username);
    return UserMapper.toModel(userEntity);
  }

  @override
  UserModel? getCurrentUser() {
    UserEntity? userEntity = _authProvider.getCurrentUserEntity();
    if (userEntity != null) {
      return UserMapper.toModel(userEntity);
    }
    return null;
  }

  @override
  Future<UserModel> logInUser({
    required String email,
    required String password,
  }) async {
    await _authProvider.logInUser(
      email: email,
      password: password,
    );
    UserModel userModel = getCurrentUser()!;
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
  Future<void> updateUsername(String username) async {
    UserModel? userModel = getCurrentUser();
    if (userModel != null) {
      await _databaseProvider.updateUsernameData(
        userModel.id,
        username,
      );
    }
  }

  @override
  Future<void> uploadImage(File image) async {
    UserModel? userModel = getCurrentUser();
    if (userModel != null) {
      final String? photoURL = await _storageProvider.uploadImage(
        image: image,
        userId: userModel.id.toString(),
      );
      if (photoURL != null) {
        setUserPhoto(photoURL);
      }
    }
  }

  @override
  Future<String> downloadImage() async {
    UserModel? userModel = getCurrentUser();
    if (userModel != null) {
      return await _storageProvider.downloadImage(
        userId: userModel.id.toString(),
      );
    }
    return "";
  }

  @override
  Future<String> getUsernameByID(String userID) async {
    return await _databaseProvider.getUsernameByID(userID);
  }
}
