import 'dart:io';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home.dart';

class UserInListCell extends StatelessWidget {
  final ChatModel chatModel;
  final ChatMemberModel chatMemberModel;
  final bool isShowingToCreator;
  final bool isCreator;
  const UserInListCell({
    super.key,
    required this.chatMemberModel,
    required this.isShowingToCreator,
    required this.isCreator,
    required this.chatModel,
  });

  @override
  Widget build(BuildContext context) {
    final FileImage? image;
    if (chatMemberModel.image != null) {
      image = FileImage(File(chatMemberModel.image!));
    } else {
      image = null;
    }
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    MessageBloc messageBloc = BlocProvider.of<MessageBloc>(context);
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: image,
                  maxRadius: 30,
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          chatMemberModel.username == ""
                              ? "NoName"
                              : chatMemberModel.username!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Visibility(
                          visible: isCreator,
                          child: const Icon(Icons.star),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !isCreator
                ? isShowingToCreator
                : false, // to be sure that we do not showing remove user from chat icon for user themself
            child: TextButton(
              onPressed: () async {
                final shouldLogout = await showRemoveMemberDialog(context);
                if (shouldLogout) {
                  chatBloc.add(RemoveUserFromChatEvent(
                    userID: chatMemberModel.uid,
                    chat: chatModel,
                  ));
                  messageBloc.add(PostServiceMessageToDBEvent(
                    serviceType: "remove",
                    username: chatMemberModel.username,
                    chatID: chatModel.id,
                    timestamp: DateTime.now().millisecondsSinceEpoch,
                  ));
                } else {}
              },
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
