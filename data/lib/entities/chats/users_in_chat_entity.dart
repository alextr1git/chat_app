import 'package:firebase_auth/firebase_auth.dart';

class UsersInChatEntity {
  final int chatId;
  Map<String, bool> users;

  UsersInChatEntity({
    required this.chatId,
    required this.users,
  });

  factory UsersInChatEntity.fromJson(Map<String, dynamic> json) {
    Map<String, bool> usersMap = Map<String, bool>.from(json);
    return UsersInChatEntity(
      chatId: json['chatId'],
      users: usersMap,
    );
  }
}
