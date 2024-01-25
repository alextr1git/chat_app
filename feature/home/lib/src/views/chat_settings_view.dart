import 'package:auth/auth.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:home/src/widgets/users_list_cell.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class ChatSettingsView extends StatelessWidget {
  const ChatSettingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MessageBloc messageBloc = BlocProvider.of<MessageBloc>(context);
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Chat settings",
          style: TextStyle(fontSize: 24),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: Row(
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      messageBloc.add(PopChatSettingsViewEvent());
                    },
                    child: const Icon(Icons.arrow_back_ios_sharp)),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Inviting link for this chat",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text: chatBloc.state.currentChat!.id))
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Copied to your clipboard!')));
                            });
                          },
                          child: const Icon(
                            Icons.link,
                            size: 40,
                          ),
                        ),
                        Text(
                          chatBloc.state.currentChat!.id,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              height: 10,
            ),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListView.builder(
                        itemCount: chatBloc.state.activeMembersOfChat!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final chatMemberModel =
                              chatBloc.state.activeMembersOfChat![index];
                          return UserInListCell(
                            chatMemberModel: chatMemberModel,
                            isCreator: chatMemberModel.uid ==
                                chatBloc.state.currentChat!.creatorId,
                            isShowingToCreator:
                                (messageBloc.state as MessageLoadedState)
                                        .currentUser
                                        .id ==
                                    chatBloc.state.currentChat!.creatorId,
                          );
                        }),
                  ),
                );
              },
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                height: 200,
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.redAccent[700],
                    ),
                    onPressed: () async {
                      final shouldLogout = await showLeaveChatDialog(context);
                      if (shouldLogout) {
                        chatBloc.add(RemoveUserFromChatEvent(
                          userID: "self",
                          chat: chatBloc.state.currentChat!,
                        ));

                        messageBloc.add(PostServiceMessageToDBEvent(
                          serviceType: "leave",
                          username: null,
                          chatID: chatBloc.state.currentChat!.id,
                          timestamp: DateTime.now().millisecondsSinceEpoch,
                        ));
                      } else {}
                    },
                    child: const Text("Leave chat"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
