import 'dart:async';

import 'package:data/entities/chats/chat_entity.dart';
import 'package:data/entities/chats/message_entity.dart';

abstract class RealTimeDatabaseProvider {
  Future<void> createNewChat(
    ChatEntity chatEntity,
    String userId,
  );

  Future<List<ChatEntity>?> getChatsForUser(
    String userId,
  );

  Stream<MessageEntity> getMessagesForChat(
    ChatEntity chatEntity,
  );

  Future<void> postNewMessage(
    MessageEntity messageEntity,
  );
}
