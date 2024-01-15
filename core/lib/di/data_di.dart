import 'package:data/data.dart';
import 'package:data/providers/auth/authentication_provider.dart';
import 'package:data/providers/storage/storage_provider.dart';
import 'package:data/providers/storage/storage_provider_impl.dart';
import 'package:data/repositories/user/user_repository_impl.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/settings_usecases/upload_image_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:core/config/firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:settings/settings.dart';

import 'app_di.dart';

final DataDI dataDI = DataDI();

class DataDI {
  late final FirebaseAuth _firebaseAuth;
  late final FirebaseDatabase _firebaseDatabase;
  late final FirebaseStorage _firebaseStorage;

  Future<void> initDependencies() async {
    await _initFirebase();
    _firebaseAuth = _initFirebaseAuth();
    _firebaseDatabase = _initFirebaseDatabase();
    _firebaseStorage = _initFirebaseStorage();
    _initAuthResources();
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseAuth _initFirebaseAuth() => FirebaseAuth.instance;
  FirebaseDatabase _initFirebaseDatabase() => FirebaseDatabase.instance;
  FirebaseStorage _initFirebaseStorage() => FirebaseStorage.instance;

  FirebaseAuth get firebaseAuth => _firebaseAuth;
  FirebaseDatabase get firebaseDatabase => _firebaseDatabase;
  FirebaseStorage get firebaseStorage => _firebaseStorage;
  Reference get firebaseStorageRef => _firebaseStorage.ref();

  void _initAuthResources() {
    appLocator.registerLazySingleton<AuthenticationProvider>(
        () => FirebaseAuthProvider());

    appLocator
        .registerLazySingleton<StorageProvider>(() => StorageProviderImpl());

    appLocator
        .registerLazySingleton<UserRepository>(() => UserAuthRepositoryImpl(
              authProvider: appLocator.get<AuthenticationProvider>(),
              storageProvider: appLocator.get<StorageProvider>(),
            ));

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

    appLocator.registerLazySingleton<SendVerificationEmailUseCase>(
      () => SendVerificationEmailUseCase(
        userRepository: appLocator.get<UserRepository>(),
      ),
    );

    appLocator.registerLazySingleton<LogoutUserUseCase>(
      () => LogoutUserUseCase(
        userRepository: appLocator.get<UserRepository>(),
      ),
    );

    appLocator.registerLazySingleton<GetUserUseCase>(
      () => GetUserUseCase(
        userRepository: appLocator.get<UserRepository>(),
      ),
    );

    appLocator.registerLazySingleton<SetUsernameUseCase>(
      () => SetUsernameUseCase(
        userRepository: appLocator.get<UserRepository>(),
      ),
    );

    appLocator.registerLazySingleton<SetUserPhotoURLUseCase>(
      () => SetUserPhotoURLUseCase(
        userRepository: appLocator.get<UserRepository>(),
      ),
    );

    appLocator
        .registerLazySingleton<UploadImageUseCase>(() => UploadImageUseCase(
              userRepository: appLocator.get<UserRepository>(),
            ));

    appLocator.registerLazySingleton<DownloadImageUseCase>(() =>
        DownloadImageUseCase(userRepository: appLocator.get<UserRepository>()));

    appLocator.registerLazySingleton<ImageHelper>(() => ImageHelper());
  }
}
