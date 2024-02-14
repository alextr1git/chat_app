import 'dart:async';
import 'package:domain/domain.dart';

abstract class ChatRepository {
  Future<ChatModel?> createNewChat(ChatModel chatModel);
  Future<ChatModel?> joinChat(String chatId);
  Future<void> removeUserFromChat({
    required String userID,
    required String chatID,
  });
  Stream<List<ChatModel>> getChatsForUser();
  Future<List<ChatMemberModel>> getMembersOfChat(String chatId);
  Stream<List<MessageModel>> getMessagesForChat(ChatModel chatModel);
  Future<Map<String, MessageModel>> getModelsOfLastMessagesOfChat(
      List<ChatModel> listOfChatModels);
  Future<void> postMessage(MessageModel messageModel);

  Future<void> setListeningStatus({
    required String chatID,
    required bool status,
  });
}
