import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class SingleChatWrapperView extends StatelessWidget {
  const SingleChatWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter(
      builder: (BuildContext context, Widget child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<SingleChatBloc>(
              create: (BuildContext context) => SingleChatBloc(
                router: navigationGetIt.get<AppRouter>(),
                postMessageUseCase: appLocator.get<PostMessageUseCase>(),
                createNewChatUseCase: appLocator.get<CreateNewChatUseCase>(),
                getMessagesForChatUseCase:
                    appLocator.get<GetMessagesForChatUseCase>(),
                getMembersOfChatUsecase:
                    appLocator.get<GetMembersOfChatUseCase>(),
                joinChatUseCase: appLocator.get<JoinChatUseCase>(),
                removeUserFromChatUseCase:
                    appLocator.get<RemoveUserFromChatUseCase>(),
                getUserUseCase: appLocator.get<GetUserUseCase>(),
              ),
            ),
            BlocProvider<MessageBloc>(
                create: (BuildContext context) => MessageBloc(
                      getMessagesForChatUseCase:
                          appLocator.get<GetMessagesForChatUseCase>(),
                      postMessageUseCase: appLocator.get<PostMessageUseCase>(),
                      getUserUseCase: appLocator.get<GetUserUseCase>(),
                      getUsernameByIDUseCase:
                          appLocator.get<GetUsernameByIDUseCase>(),
                    )),
          ],
          child: child,
        );
      },
    );
  }
}
