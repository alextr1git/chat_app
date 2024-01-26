import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:navigation/navigation.dart';

import '../widgets/connect_to_chat_reusable_view.dart';

@RoutePage()
class AddChatView extends StatelessWidget {
  const AddChatView({super.key});

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    MessageBloc messageBloc = BlocProvider.of<MessageBloc>(context);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('!Add chat!'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: "!Create!",
                icon: Icon(Icons.add),
              ),
              Tab(
                text: "!Connect!",
                icon: Icon(Icons.chat_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ConnectToChat(
              textFieldHint: 'Enter new chat name',
              textFieldLabel: 'Name',
              buttonText: 'Create',
              showColorPicker: true,
              onPressed: (
                String text,
                int? color,
              ) {
                ChatModel chatModel = ChatModel(
                  id: "0",
                  title: text,
                  lastMessageId: "0",
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                  messageCount: 0,
                  creatorId: "0",
                  color: color!,
                );
                chatBloc.add(CreateNewChatEvent(chatModel: chatModel));
              },
              icon: const Icon(Icons.abc_rounded),
            ),
            ConnectToChat(
              textFieldHint: 'Enter link to chat',
              textFieldLabel: 'Link',
              buttonText: 'Connect',
              showColorPicker: false,
              onPressed: (
                String text,
                int? color,
              ) {
                chatBloc.add(JoinChatEvent(chatID: text));
                if (chatBloc.state.error == null) {
                  messageBloc.add(PostServiceMessageToDBEvent(
                    serviceType: "join",
                    username: null,
                    chatID: chatBloc.state.currentChat!.id,
                    timestamp: DateTime.now().millisecondsSinceEpoch,
                  ));
                  chatBloc.add(PopChatRouteEvent());
                  chatBloc.add(NavigateToPersonalChatViewEvent(
                      selectedChat: chatBloc.state.currentChat!));
                }
              },
              icon: const Icon(Icons.link),
            ),
          ],
        ),
      ),
    );
  }
}
