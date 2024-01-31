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
import 'package:collection/collection.dart';
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
  late final ScrollController _listViewScrollController;
  bool _firstAutoscrollExecuted = false;
  bool _shouldAutoscroll = false;
  late final ChatBloc chatBloc;
  late final MessageBloc messageBloc;

  void _scrollToBottom() {
    _listViewScrollController
        .jumpTo(_listViewScrollController.position.maxScrollExtent);
  }

  void _scrollListener() {
    if (_listViewScrollController.hasClients &&
        _listViewScrollController.position.pixels !=
            _listViewScrollController.position.maxScrollExtent) {
      _shouldAutoscroll = true;
    } else {
      _shouldAutoscroll = false;
    }
  }

  @override
  void initState() {
    _messageTextController = TextEditingController();
    _listViewScrollController = ScrollController();
    _listViewScrollController.addListener(_scrollListener);
    chatBloc = BlocProvider.of<ChatBloc>(context);
    messageBloc = BlocProvider.of<MessageBloc>(context);
    chatBloc.add(GetMembersOfChatEvent(chatModel: widget.chatModel));
    messageBloc.add(InitMessageEvent(currentChat: widget.chatModel));
    super.initState();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    _listViewScrollController.removeListener(_scrollListener);
    _listViewScrollController.dispose();
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
                      chatBloc.add(NavigateToChatsViewEvent());
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
          Builder(
            builder: (context) {
              final messageState = context.watch<MessageBloc>().state;
              final chatState = context.watch<ChatBloc>().state;
              if (messageState is MessageLoadedState &&
                  chatState is ChatsSingleChatDataFetchedState) {
                if (messageState.listOfMessageModel.isEmpty) {
                  return Expanded(
                      child: Center(
                          child: Text(LocaleKeys
                              .personal_chat_view_no_messages_yet
                              .tr())));
                } else {
                  return Expanded(
                      child: ListView.builder(
                    controller: _listViewScrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: messageState.listOfMessageModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        setState(() {
                          if (!_firstAutoscrollExecuted &&
                              _listViewScrollController.hasClients) {
                            _firstAutoscrollExecuted = true;
                            _scrollToBottom();
                          }
                        });
                      });
                      ChatMemberModel? chatMember =
                          (chatState.allMembersOfChat != null &&
                                  chatState.allMembersOfChat!.isNotEmpty)
                              ? chatState
                                  .allMembersOfChat!
                                  .firstWhereOrNull((member) =>
                                      member.uid ==
                                      messageState
                                          .listOfMessageModel[index].senderId)
                              : null;
                      String? username;
                      FileImage? image;
                      if (chatMember != null) {
                        if (chatMember.username != null) {
                          username = chatMember.username;
                        }
                        if (chatMember.image != null) {
                          image = FileImage(File(chatMember.image!));
                        }
                      }
                      return messageState.currentUser.id ==
                              messageState.listOfMessageModel[index].senderId
                          ? ChatOwnerMessage(
                              colorOfMessage: Color(widget.chatModel.color),
                              message: messageState
                                  .listOfMessageModel[index].message)
                          : (messageState.listOfMessageModel[index].senderId ==
                                  "service"
                              ? ServiceMessage(
                                  message: messageState
                                      .listOfMessageModel[index].message,
                                )
                              : (ChatMemberMessage(
                                  username: username,
                                  message: messageState
                                      .listOfMessageModel[index].message,
                                  image: image)));
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Visibility(
                          visible: _shouldAutoscroll,
                          child: FloatingActionButton(
                            heroTag: "Button 1",
                            onPressed: () {
                              setState(() {
                                if (_listViewScrollController.hasClients &&
                                    _shouldAutoscroll) {
                                  _scrollToBottom();
                                }
                              });
                            },
                            child: const Icon(Icons.arrow_downward_outlined),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
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
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                              heroTag: "Button 2",
                              onPressed: () {
                                if (messageBloc.state is MessageLoadedState) {
                                  MessageModel messageModel = MessageModel(
                                    id: "0",
                                    chatId: widget.chatModel.id,
                                    senderId: (messageBloc.state
                                            as MessageLoadedState)
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
                              backgroundColor:
                                  lightTheme.colorScheme.onBackground,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
