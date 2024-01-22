import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:home/src/messages_bloc/message_bloc.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class PersonalChatView extends StatelessWidget {
  final ChatModel chatModel;

  const PersonalChatView({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    MessageBloc messageBloc = BlocProvider.of<MessageBloc>(context);
    messageBloc.add(GetMessagesForChatEvent(currentChat: chatModel));
    chatBloc.add(GetMembersOfChatEvent(chatModel: chatModel));
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
                    },
                    child: const Icon(Icons.arrow_back_ios_sharp)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.amber,
                        ),
                        child: Text(
                          chatModel.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      messageBloc.add(
                          NavigateToChatSettingsEvent(currentChat: chatModel));
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
                return StreamBuilder(
                    stream: state.messageModelsStream,
                    builder: (context, snapshot) {
                      final tilesList = <ListTile>[];
                      if (snapshot.hasData) {
                        print(snapshot.data!.message);
                        tilesList.add(ListTile(
                          title: Text(snapshot.data!.message),
                        ));
                      } else {
                        return const Text("No messages yet!");
                      }
                      return Expanded(
                          child: ListView(
                        children: tilesList,
                      ));
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
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
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {},
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

/*Expanded(
              child: SingleChildScrollView(
            child: Align(
              child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (messages[index].messageType == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].messageType == "receiver"
                              ? Colors.grey.shade200
                              : Colors.blue[200]),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          messages[index].messageContent,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )),*/
