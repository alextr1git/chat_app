import 'package:flutter/material.dart';

import '../widgets/connect_to_chat_reusable_view.dart';

class AddChatView extends StatelessWidget {
  const AddChatView({super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => print("Created"),
              icon: const Icon(Icons.abc_rounded),
            ),
            ConnectToChat(
              textFieldHint: 'Enter link to chat',
              textFieldLabel: 'Link',
              buttonText: 'Connect',
              onPressed: () => print("Connected"),
              icon: const Icon(Icons.link),
            ),
          ],
        ),
      ),
    );
  }
}
