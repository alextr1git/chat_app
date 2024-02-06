import 'dart:async';

import 'package:data/entities/chats/chat_entity.dart';
import 'package:data/entities/chats/message_entity.dart';

import '../../entities/chat_members/chat_member_entity.dart';

abstract class RealTimeDatabaseProvider {
  Future<ChatEntity?> createNewChat(
    ChatEntity chatEntity,
    String userId,
  );
  Future<ChatEntity?> joinChat(String chatID, String userID);
  Future<void> removeUserFromChat({
    required String userID,
    required String chatID,
  });

  Stream<List<ChatEntity>> getChatsForUser(
    String userId,
  );
  Future<List<ChatMemberEntity>> getMembersOfChat(
    String chatId,
  );
  Stream<List<MessageEntity>> getMessagesForChat(
    ChatEntity chatEntity,
  );

  Future<String> getUsernameByID(String userID);
  Future<void> updateUsernameData(
    String userId,
    String username,
  );

  Future<void> setListeningStatus({
    required String chatID,
    required String userID,
    required bool status,
  });

  Future<void> notifyMembersAboutChatChanges({
    required String chatID,
  });

  Future<void> postNewMessage(
    MessageEntity messageEntity,
  );
  Future<Map<String, MessageEntity>> getLastMessagesOfChat(
      List<ChatEntity> listOfChatEntities);
}
