import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:home/src/widgets/personal_chat_content.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class PersonalChatView extends StatefulWidget {
  final ChatModel chatModel;
  const PersonalChatView({
    super.key,
    required this.chatModel,
  });

  @override
  State<PersonalChatView> createState() => _PersonalChatViewState();
}

class _PersonalChatViewState extends State<PersonalChatView> {
  late final TextEditingController _messageTextController;
  late final ScrollController _listViewScrollController;
  bool _shouldAutoscroll = false;
  late final SingleChatBloc singleChatBloc;
  late final MessageBloc messageBloc;

  void _scrollToBottom() {
    _listViewScrollController
        .jumpTo(_listViewScrollController.position.minScrollExtent);
  }

  void _scrollListener() {
    if (_listViewScrollController.hasClients &&
        _listViewScrollController.position.pixels >
            _listViewScrollController.position.minScrollExtent + 150) {
      if (!_shouldAutoscroll) {
        setState(() {
          _shouldAutoscroll = true;
        });
      }
    } else {
      if (_shouldAutoscroll) {
        setState(() {
          _shouldAutoscroll = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _messageTextController = TextEditingController();
    _listViewScrollController = ScrollController();
    _listViewScrollController.addListener(_scrollListener);
    singleChatBloc = BlocProvider.of<SingleChatBloc>(context);
    messageBloc = BlocProvider.of<MessageBloc>(context);
    singleChatBloc.add(GetMembersOfChatEvent(chatModel: widget.chatModel));
    messageBloc.add(InitMessageEvent(currentChat: widget.chatModel));
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
                      singleChatBloc.add(NavigateToChatsViewEvent());
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
                      singleChatBloc.add(NavigateToChatSettingsEvent(
                          singleChatBloc: singleChatBloc,
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
              final singleChatState = context.watch<SingleChatBloc>().state;
              if (messageState is MessageLoadedState &&
                  singleChatState is ChatsSingleChatDataFetchedState) {
                if (messageState.listOfMessageModel.isEmpty) {
                  return Expanded(
                      child: Center(
                          child: Text(LocaleKeys
                              .personal_chat_view_no_messages_yet
                              .tr())));
                } else {
                  return Expanded(
                    child: Stack(
                      children: [
                        ListView(
                          reverse: true,
                          controller: _listViewScrollController,
                          padding: const EdgeInsets.all(8),
                          children: [
                            for (MessageModel message in messageState
                                .listOfMessageModel.reversed
                                .toList())
                              GeneralMessage(
                                listOfChatMembers:
                                    singleChatState.allMembersOfChat,
                                messageModel: message,
                                currentUserID: messageState.currentUser.id,
                                chatModel: singleChatState.currentChat,
                              ),
                          ],
                        ),
                        if (_shouldAutoscroll)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
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
                                child:
                                    const Icon(Icons.arrow_downward_outlined),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
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
                          heroTag: "Button 2",
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
