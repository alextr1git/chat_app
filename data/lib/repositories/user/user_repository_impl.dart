import 'package:data/data.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:domain/domain.dart';
import '../../providers/auth/firebase_auth_provider.dart';
class UserAuthRepositoryImpl implements UserRepository{

  final AuthProvider provider;

const UserAuthRepositoryImpl(this.provider);

factory UserAuthRepositoryImpl.firebase() => UserAuthRepositoryImpl(FirebaseAuthProvider());

@override
Future<UserModel> createUser({
  required String email,
  required String password,
  required String userName,
}) async {
  UserEntity userEntity = await provider.createUser(
    email: email,
    password: password,
    userName: userName,
  );
  return UserMapper.toModel(userEntity);
}

@override
UserModel? get currentUser => (provider.currentUser != null) ? UserMapper.toModel(provider.currentUser!) : null;

@override
Future<UserModel> logInUser({
  required String email,
  required String password,
  required String userName,
}) async{
  UserEntity userEntity = await provider.logInUser(
    email: email,
    password: password,
    userName: userName,
  );
  return UserMapper.toModel(userEntity);
}
@override
Future<void> logOutUser() => provider.logOutUser();

@override
Future<void> sendVerification() => provider.sendVerification();

@override
Future<void> initialize() => provider.initialize();
  }


}