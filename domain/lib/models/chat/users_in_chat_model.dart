import 'package:flutter/material.dart';

@immutable
class UsersInChatModel {
  final int chatId;
  final Map<String, bool> users;

  const UsersInChatModel({
    required this.chatId,
    required this.users,
  });

  UsersInChatModel copyWith({
    int? chatId,
    Map<String, bool>? users,
  }) =>
      UsersInChatModel(
        chatId: chatId ?? this.chatId,
        users: users ?? this.users,
      );
}
