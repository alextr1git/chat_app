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
              onPressed: (String text) {
                chatBloc.add(CreateNewChatEvent(chatTitle: text));
              },
              icon: const Icon(Icons.abc_rounded),
            ),
            ConnectToChat(
              textFieldHint: 'Enter link to chat',
              textFieldLabel: 'Link',
              buttonText: 'Connect',
              onPressed: (String text) {
                chatBloc.add(JoinChatEvent(chatID: text));
              },
              icon: const Icon(Icons.link),
            ),
          ],
        ),
      ),
    );
  }
}
