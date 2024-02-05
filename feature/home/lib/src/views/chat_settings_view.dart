import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class ChatSettingsView extends StatelessWidget {
  final ChatModel chatModel;

  const ChatSettingsView({
    super.key,
    required this.chatModel,
  });

  @override
  Widget build(BuildContext context) {
    final SingleChatBloc singleChatBloc =
        BlocProvider.of<SingleChatBloc>(context);
    final MessageBloc messageBloc = BlocProvider.of<MessageBloc>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          LocaleKeys.chat_settings_view_title.tr(),
          style: const TextStyle(fontSize: 24),
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
                      singleChatBloc.add(
                          PopChatSettingsViewEvent(currentChat: chatModel));
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
            ChatSettingsLinkArea(
              chatModel: chatModel,
            ),
            const Divider(
              height: 10,
            ),
            BlocBuilder<SingleChatBloc, SingleChatState>(
              builder: (context, state) {
                if (state is ChatsSingleChatDataFetchedState) {
                  return Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView.builder(
                          itemCount: state.activeMembersOfChat.length,
                          itemBuilder: (BuildContext context, int index) {
                            final chatMemberModel =
                                state.activeMembersOfChat[index];
                            return UserInListCell(
                              chatModel: chatModel,
                              chatMemberModel: chatMemberModel,
                              isCreator: chatMemberModel.uid ==
                                  state.currentChat.creatorId,
                              isShowingToCreator: (singleChatBloc.state
                                          as ChatsSingleChatDataFetchedState)
                                      .currentUser
                                      .id ==
                                  state.currentChat.creatorId,
                            );
                          }),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
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
                        messageBloc.add(DisposeMessagesBlocEvent());
                        singleChatBloc.add(RemoveUserFromChatEvent(
                          userID: "self",
                          chat: chatModel,
                        ));
                      } else {}
                    },
                    child: Text(LocaleKeys.chat_settings_view_leave_chat.tr()),
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
