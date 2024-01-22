import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:home/home.dart';
import 'package:navigation/navigation.dart';

class GlobalBlocProvider extends StatelessWidget {
  final Widget child;
  const GlobalBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
                  registerUseCase: appLocator.get<RegisterUsecase>(),
                  loginUseCase: appLocator.get<LoginUseCase>(),
                  checkUserAuthenticationUseCase:
                      appLocator.get<CheckUserAuthenticationUseCase>(),
                  sendVerificationEmailUseCase:
                      appLocator.get<SendVerificationEmailUseCase>(),
                  logoutUserUseCase: appLocator.get<LogoutUserUseCase>(),
                  setUsernameUseCase: appLocator.get<SetUsernameUseCase>(),
                  setUserPhotoURLUseCase:
                      appLocator.get<SetUserPhotoURLUseCase>(),
                  router: navigationGetIt.get<AppRouter>(),
                )),
        BlocProvider<ChatBloc>(
            create: (BuildContext context) => ChatBloc(
                  router: navigationGetIt.get<AppRouter>(),
                  postMessageUseCase: appLocator.get<PostMessageUseCase>(),
                  createNewChatUseCase: appLocator.get<CreateNewChatUseCase>(),
                  getChatsForUserUseCase:
                      appLocator.get<GetChatsForUserUseCase>(),
                  getMessagesForChatUseCase:
                      appLocator.get<GetMessagesForChatUseCase>(),
                  getMembersOfChatUsecase:
                      appLocator.get<GetMembersOfChatUsecase>(),
                )),
        BlocProvider<MessageBloc>(
            create: (BuildContext context) => MessageBloc(
                  getMessagesForChatUseCase:
                      appLocator.get<GetMessagesForChatUseCase>(),
                  postMessageUseCase: appLocator.get<PostMessageUseCase>(),
                  router: appLocator.get<AppRouter>(),
                )),
      ],
      child: child,
    );
  }
}
