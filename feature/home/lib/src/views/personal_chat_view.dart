import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:home/src/messages_bloc/message_bloc.dart';
import 'package:home/src/widgets/service_message_ui.dart';
import 'package:navigation/navigation.dart';

import '../widgets/chat_member_message_ui.dart';
import '../widgets/chat_owner_message_ui.dart';

@RoutePage()
class PersonalChatView extends StatefulWidget {
  final ChatModel chatModel;

  const PersonalChatView({super.key, required this.chatModel});

  @override
  State<PersonalChatView> createState() => _PersonalChatViewState();
}

class _PersonalChatViewState extends State<PersonalChatView> {
  late final TextEditingController _messageTextController;
  late final ChatBloc chatBloc;
  late final MessageBloc messageBloc;
  @override
  void initState() {
    _messageTextController = TextEditingController();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    messageBloc = BlocProvider.of<MessageBloc>(context);
    chatBloc.add(GetMembersOfChatEvent(chatModel: chatBloc.state.currentChat!));
    messageBloc.add(InitMessageEvent(currentChat: chatBloc.state.currentChat!));
    super.initState();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      chatBloc.add(PopChatRouteEvent());
                      messageBloc.add(DisposeMessagesBlocEvent());
                    },
                    child: const Icon(Icons.arrow_back_ios_sharp)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.chatModel.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      chatBloc.add(
                          GetMembersOfChatEvent(chatModel: widget.chatModel));
                      messageBloc.add(NavigateToChatSettingsEvent(
                          currentChat: widget.chatModel));
                    },
                    child: const Icon(
                      Icons.settings,
                      size: 30,
                    )),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              if (state is MessageLoadedState) {
                if (state.listOfMessageModel.isEmpty) {
                  return Expanded(
                      child: Center(
                          child: Text(LocaleKeys
                              .personal_chat_view_no_messages_yet
                              .tr())));
                } else {
                  return Expanded(
                      child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.listOfMessageModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      return state.currentUser.id ==
                              state.listOfMessageModel[index].senderId
                          ? ChatOwnerMessage(
                              colorOfMessage: Color(widget.chatModel.color),
                              message: state.listOfMessageModel[index].message)
                          : (state.listOfMessageModel[index].senderId ==
                                  "service"
                              ? ServiceMessage(
                                  message:
                                      state.listOfMessageModel[index].message,
                                )
                              : (ChatMemberMessage(
                                  username:
                                      (chatBloc.state.allMembersOfChat != null)
                                          ? chatBloc.state.allMembersOfChat!
                                              .firstWhere((member) =>
                                                  member.uid ==
                                                  state
                                                      .listOfMessageModel[index]
                                                      .senderId)
                                              .username
                                          : null,
                                  message:
                                      state.listOfMessageModel[index].message,
                                  image: null,
                                )));
                    },
                  ));
                }
              } else {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _messageTextController,
                            decoration: InputDecoration(
                              hintText: LocaleKeys
                                  .personal_chat_view_write_message
                                  .tr(),
                              hintStyle: const TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            if (messageBloc.state is MessageLoadedState) {
                              MessageModel messageModel = MessageModel(
                                id: "0",
                                chatId: widget.chatModel.id,
                                senderId:
                                    (messageBloc.state as MessageLoadedState)
                                        .currentUser
                                        .id,
                                message: _messageTextController.text,
                                timeStamp:
                                    DateTime.now().millisecondsSinceEpoch,
                              );
                              messageBloc.add(PostMessageToDBEvent(
                                  messageModel: messageModel));
                            }
                            _messageTextController.text = "";
                          },
                          backgroundColor: lightTheme.colorScheme.onBackground,
                          elevation: 1,
                          child: const Icon(
                            Icons.send,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
