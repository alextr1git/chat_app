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
    List<MessageModel> listOfMessageModel = [];
    return BlocProvider(
      create: (BuildContext context) => MessageBloc(
        getMessagesForChatUseCase: appLocator.get<GetMessagesForChatUseCase>(),
        postMessageUseCase: appLocator.get<PostMessageUseCase>(),
      )..add(GetMessagesForChatEvent(chatModel: chatModel)),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 10,
                top: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: null,
                    maxRadius: 26,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          chatModel.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                return StreamBuilder<List<MessageModel>>(
                    stream: context
                        .read<MessageBloc>()
                        .state
                        .messageModelsStreamController!
                        .stream,
                    builder: (context, snapshot) {
                      final tilesList = <ListTile>[];
                      if (snapshot.hasData) {
                        snapshot.data!.forEach((message) {
                          tilesList.add(ListTile(
                            title: Text(message.message),
                          ));
                        });
                      } else {
                        return Text("No messages yet!");
                      }
                      return Expanded(
                          child: ListView(
                        children: tilesList,
                      ));
                    });
              },
            ),

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
              ),
            )
          ],
        ),
      ),
    );
  }
}
