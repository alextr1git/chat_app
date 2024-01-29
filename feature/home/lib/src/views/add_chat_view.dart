import 'package:core/core.dart';
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
          title: Text(LocaleKeys.add_chat_view_add_chat_title.tr()),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: LocaleKeys.add_chat_view_create_title.tr(),
                icon: const Icon(Icons.add),
              ),
              Tab(
                text: LocaleKeys.add_chat_view_connect_title.tr(),
                icon: const Icon(Icons.chat_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ConnectToChat(
              textFieldHint: LocaleKeys.add_chat_view_name_hint.tr(),
              textFieldLabel: LocaleKeys.add_chat_view_name_label.tr(),
              buttonText: LocaleKeys.add_chat_view_create_button.tr(),
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
              textFieldHint: LocaleKeys.add_chat_view_link_hint.tr(),
              textFieldLabel: LocaleKeys.add_chat_view_link_label.tr(),
              buttonText: LocaleKeys.add_chat_view_connect_button.tr(),
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
