import 'package:data/data.dart';
import 'package:data/providers/auth/authentication_provider.dart';
import 'package:data/repositories/user/user_repository_impl.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/auth_usecases/check_user_auth_usecase.dart';
import 'package:domain/usecases/auth_usecases/login_usecase.dart';
import 'package:domain/usecases/auth_usecases/register_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:core/config/firebase_options.dart';

import 'app_di.dart';

final DataDI dataDI = DataDI();

class DataDI {
  late final FirebaseAuth _firebaseAuth;

  Future<void> initDependencies() async {
    await _initFirebase();
    _firebaseAuth = _initFirebaseAuth();
    _initAuthResources();
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseAuth _initFirebaseAuth() => FirebaseAuth.instance;
  FirebaseAuth get firebaseAuth => _firebaseAuth;

  void _initAuthResources() {
    appLocator.registerLazySingleton<AuthenticationProvider>(
      () => FirebaseAuthProvider(),
    );

    appLocator.registerLazySingleton<UserRepository>(
      () => UserAuthRepositoryImpl.firebase(),
    );

    appLocator.registerLazySingleton<RegisterUsecase>(
      () => RegisterUsecase(
        userRepository: appLocator.get<UserRepository>(),
      ),
    );

    appLocator.registerLazySingleton<LoginUsecase>(
      () => LoginUsecase(
        userRepository: appLocator.get<UserRepository>(),
      ),
    );

    appLocator.registerLazySingleton<CheckUserAuthenticationUseCase>(
      () => CheckUserAuthenticationUseCase(
        userRepository: appLocator.get<UserRepository>(),
      ),
    );
  }
}
