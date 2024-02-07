import 'dart:io';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; //! necessary for firstWhereOrNull
import 'package:home/home.dart';

class GeneralMessage extends StatelessWidget {
  final List<ChatMemberModel> listOfChatMembers;
  final MessageModel messageModel;
  final String currentUserID;
  final ChatModel chatModel;
  const GeneralMessage({
    super.key,
    required this.listOfChatMembers,
    required this.messageModel,
    required this.currentUserID,
    required this.chatModel,
  });

  @override
  Widget build(BuildContext context) {
    if (currentUserID == messageModel.senderId) {
      return ChatOwnerMessage(
          colorOfMessage: Color(chatModel.color),
          message: messageModel.message);
    } else {
      if (messageModel.senderId == "service") {
        return ServiceMessage(
          message: messageModel.message,
        );
      } else {
        ChatMemberModel? chatMember = listOfChatMembers.isNotEmpty
            ? listOfChatMembers.firstWhereOrNull(
                (member) => member.uid == messageModel.senderId)
            : null;
        if (chatMember != null) {
          return ChatMemberMessage(
            username: chatMember.username,
            message: messageModel.message,
            image: chatMember.image != null
                ? FileImage(File(chatMember.image!))
                : null,
          );
        }
      }
    }
    return const SizedBox();
  }
}
