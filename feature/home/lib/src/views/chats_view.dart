import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatsBloc>(
      create: (BuildContext context) => ChatsBloc(
        router: navigationGetIt.get<AppRouter>(),
        getChatsForUserUseCase: appLocator.get<GetChatsForUserUseCase>(),
        getLastMessageOfChatUseCase:
            appLocator.get<GetLastsMessagesOfChatUseCase>(),
        inverseListeningStatusUseCase:
            appLocator.get<SetListeningStatusUseCase>(),
      ),
      child: const ChatsContent(),
    );
  }
}
