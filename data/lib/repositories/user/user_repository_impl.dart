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
  Future<void> updateUsername(String username) async {
    await _databaseProvider.updateUsernameData(
      currentUser!.id,
      username,
    );
  }

  @override
  Future<void> uploadImage(File image) async {
    final String? photoURL = await _storageProvider.uploadImage(
      image: image,
      userId: currentUser!.id.toString(),
    );
    if (photoURL != null) {
      setUserPhoto(photoURL);
    }
  }

  @override
  Future<String> downloadImage() async {
    return await _storageProvider.downloadImage(
      userId: currentUser!.id.toString(),
    );
  }

  @override
  Future<String> getUsernameByID(String userID) async {
    return await _databaseProvider.getUsernameByID(userID);
  }
}
