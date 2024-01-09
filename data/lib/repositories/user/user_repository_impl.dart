import 'package:data/data.dart';
import '../../providers/auth/authentication_provider.dart';
import 'package:domain/domain.dart';
import '../../providers/auth/firebase_auth_provider.dart';

class UserAuthRepositoryImpl implements UserRepository {
  final AuthenticationProvider provider;

  const UserAuthRepositoryImpl(this.provider);

  factory UserAuthRepositoryImpl.firebase() =>
      UserAuthRepositoryImpl(FirebaseAuthProvider());

  @override
  Future<UserModel> createUser({
    required String email,
    required String password,
  }) async {
    UserEntity userEntity = await provider.createUser(
      email: email,
      password: password,
    );
    return UserMapper.toModel(userEntity);
  }

  @override
  UserModel? get currentUser => (provider.currentUser != null)
      ? UserMapper.toModel(provider.currentUser!)
      : null;

  @override
  Future<UserModel> logInUser({
    required String email,
    required String password,
  }) async {
    await provider.logInUser(
      email: email,
      password: password,
    );
    UserModel userModel = currentUser!;
    return userModel;
  }

  @override
  Future<void> logOutUser() => provider.logOutUser();

  @override
  Future<void> sendVerification() => provider.sendVerification();

  @override
  Future<UserModel> checkUserAuthStatus() async {
    UserEntity userEntity = await provider.checkUserAuthStatus();
    return UserMapper.toModel(userEntity);
  }
}
