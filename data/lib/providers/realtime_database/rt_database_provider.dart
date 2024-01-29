import 'dart:async';

import 'package:data/entities/chats/chat_entity.dart';
import 'package:data/entities/chats/message_entity.dart';

import '../../entities/chat_members/chat_member_entity.dart';

abstract class RealTimeDatabaseProvider {
  Future<void> updateUsernameData(
    String userId,
    String username,
  );

  Future<ChatEntity?> createNewChat(
    ChatEntity chatEntity,
    String userId,
  );

  Future<List<ChatEntity>?> getChatsForUser(
    String userId,
  );

  Future<List<ChatMemberEntity>> getMembersOfChat(
    String chatId,
  );

  Stream<List<MessageEntity>> getMessagesForChat(
    ChatEntity chatEntity,
  );

  Future<void> postNewMessage(
    MessageEntity messageEntity,
  );

  Future<String> getUsernameByID(String userID);

  Future<Map<String, MessageEntity>> getLastMessagesOfChat(
      List<ChatEntity> listOfChatEntities);

  Future<ChatEntity?> joinChat(String chatID, String userID);

  Future<void> removeUserFromChat({
    required String userID,
    required String chatID,
  });
}
