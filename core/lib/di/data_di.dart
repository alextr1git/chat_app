import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:core/config/firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:settings/settings.dart';
import 'app_di.dart';

final DataDI dataDI = DataDI();

class DataDI {
  late final FirebaseApp _firebaseApp;
  late final FirebaseAuth _firebaseAuth;
  late final FirebaseDatabase _firebaseDatabase;
  late final FirebaseStorage _firebaseStorage;

  FirebaseAuth get firebaseAuth => _firebaseAuth;
  DatabaseReference get firebaseDatabaseRef => _firebaseDatabase.ref();
  Reference get firebaseStorageRef => _firebaseStorage.ref();

  Future<void> initDependencies() async {
    await _initFirebase();
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseDatabase = FirebaseDatabase.instanceFor(
      app: _firebaseApp,
      databaseURL:
          "https://chatapp-a0b76-default-rtdb.europe-west1.firebasedatabase.app/",
    );
    _firebaseStorage = FirebaseStorage.instanceFor(
      app: _firebaseApp,
      bucket: "gs://chatapp-a0b76.appspot.com/",
    );
    _initAuthResources();
    _initFirebaseStorageAndDatabaseResources();
    _initChatResources();
    _initSettingsResources();
  }

  Future<void> _initFirebase() async {
    _firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _initFirebaseStorageAndDatabaseResources() {
    appLocator
        .registerLazySingleton<StorageProvider>(() => StorageProviderImpl());

    appLocator.registerLazySingleton<RealTimeDatabaseProvider>(() =>
        RealTimeDatabaseProviderImpl(databaseReference: firebaseDatabaseRef));
  }

  void _initChatResources() {
    appLocator.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
          databaseProvider: appLocator.get<RealTimeDatabaseProvider>(),
          authProvider: appLocator.get<AuthenticationProvider>(),
          storageProvider: appLocator.get<StorageProvider>(),
        ));

    appLocator.registerLazySingleton<CreateNewChatUseCase>(
      () => CreateNewChatUseCase(
        chatRepository: appLocator.get<ChatRepository>(),
      ),
    );
    appLocator.registerLazySingleton<JoinChatUseCase>(
      () => JoinChatUseCase(
        chatRepository: appLocator.get<ChatRepository>(),
      ),
    );

    appLocator.registerLazySingleton<RemoveUserFromChatUseCase>(
      () => RemoveUserFromChatUseCase(
        chatRepository: appLocator.get<ChatRepository>(),
      ),
    );

    appLocator.registerLazySingleton<GetChatsForUserUseCase>(
      () => GetChatsForUserUseCase(
        chatRepository: appLocator.get<ChatRepository>(),
      ),
    );

    appLocator.registerLazySingleton<GetMembersOfChatUseCase>(
        () => GetMembersOfChatUseCase(
              chatRepository: appLocator.get<ChatRepository>(),
            ));

    appLocator.registerLazySingleton<GetLastsMessagesOfChatUseCase>(
      () => GetLastsMessagesOfChatUseCase(
        chatRepository: appLocator.get<ChatRepository>(),
      ),
    );

    appLocator.registerLazySingleton<GetMessagesForChatUseCase>(
      () => GetMessagesForChatUseCase(
        chatRepository: appLocator.get<ChatRepository>(),
      ),
    );

    appLocator.registerLazySingleton<PostMessageUseCase>(
      () =>
          PostMessageUseCase(chatRepository: appLocator.get<ChatRepository>()),
    );

    appLocator.registerLazySingleton<SetListeningStatusUseCase>(
      () => SetListeningStatusUseCase(
          chatRepository: appLocator.get<ChatRepository>()),
    );
  }

  void _initSettingsResources() {
    appLocator.registerLazySingleton<GetUsernameByIDUseCase>(
      () => GetUsernameByIDUseCase(
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

  void _initAuthResources() {
    appLocator.registerLazySingleton<AuthenticationProvider>(
        () => AuthenticationProviderImpl());

    appLocator
        .registerLazySingleton<UserRepository>(() => UserAuthRepositoryImpl(
              authProvider: appLocator.get<AuthenticationProvider>(),
              storageProvider: appLocator.get<StorageProvider>(),
              databaseProvider: appLocator.get<RealTimeDatabaseProvider>(),
            ));

    appLocator.registerLazySingleton<RegisterUsecase>(
      () => RegisterUsecase(
        userRepository: appLocator.get<UserRepository>(),
      ),
    );

    appLocator.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(
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
  }
}
