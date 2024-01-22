import 'dart:async';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

abstract class ChatRepository {
  Future<void> createNewChat(ChatModel chatModel);
  Future<void> postMessage(MessageModel messageModel);
  Future<List<ChatModel>> getChatsForUser();
  Future<List<ChatMemberModel>> getMembersOfChat(String chatId);
  Stream<MessageModel> getMessagesForChat(ChatModel chatModel);
}
