import 'dart:async';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

abstract class ChatRepository {
  Future<ChatModel?> createNewChat(ChatModel chatModel);
  Future<void> postMessage(MessageModel messageModel);
  Future<List<ChatModel>> getChatsForUser();
  Future<ChatModel?> joinChat(String chatId);
  Future<List<ChatMemberModel>> getMembersOfChat(String chatId);
  Stream<List<MessageModel>> getMessagesForChat(ChatModel chatModel);
  Future<MessageModel?> getModelOfLastMessageOfChat(ChatModel chatModel);
  Future<void> removeUserFromChat({
    required String userID,
    required String chatID,
  });
}
