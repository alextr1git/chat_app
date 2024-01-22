import 'dart:async';

import 'package:data/data.dart';
import 'package:data/entities/chat_members/chat_member_entity.dart';
import 'package:data/entities/chats/chat_entity.dart';
import 'package:data/entities/chats/message_entity.dart';
import 'package:data/mapper/chat/chat_mapper.dart';
import 'package:data/mapper/chat/message_mapper.dart';
import 'package:data/mapper/chat_members/chat_members_mapper.dart';
import 'package:data/providers/realtime_database/rt_database_provider.dart';
import 'package:domain/domain.dart';
import 'package:domain/repositories/repositories.dart';

import '../../providers/auth/authentication_provider.dart';
import '../../providers/storage/storage_provider.dart';

class ChatRepositoryImpl implements ChatRepository {
  final RealTimeDatabaseProvider _databaseProvider;
  final AuthenticationProvider _authProvider;
  final StorageProvider _storageProvider;

  ChatRepositoryImpl({
    required databaseProvider,
    required authProvider,
    required storageProvider,
  })  : _databaseProvider = databaseProvider,
        _authProvider = authProvider,
        _storageProvider = storageProvider;
  @override
  Future<void> postMessage(MessageModel messageModel) async {
    MessageEntity messageEntity = MessageMapper.toEntity(messageModel);
    await _databaseProvider.postNewMessage(messageEntity);
  }

  @override
  Future<void> createNewChat(ChatModel chatModel) async {
    ChatEntity chatEntity = ChatMapper.toEntity(chatModel);
    UserEntity userEntity = _authProvider.currentUser!;
    await _databaseProvider.createNewChat(chatEntity, userEntity.id);
  }

  @override
  Stream<MessageModel> getMessagesForChat(ChatModel chatModel) {
    ChatEntity chatEntity = ChatMapper.toEntity(chatModel);
    StreamController<MessageModel> messageModelsController =
        StreamController<MessageModel>();
    print(chatModel.id);
    _databaseProvider.getMessagesForChat(chatEntity).listen((event) {
      messageModelsController.add(MessageMapper.toModel(event));
    });

    return messageModelsController.stream;
  }

  @override
  Future<List<ChatModel>> getChatsForUser() async {
    List<ChatModel> listOfChatModels = [];
    String userId = _authProvider.currentUser!.id;
    List<ChatEntity>? listOfChatEntities =
        await _databaseProvider.getChatsForUser(userId);
    if (listOfChatEntities != null) {
      listOfChatEntities.forEach((entity) {
        listOfChatModels.add(ChatMapper.toModel(entity));
      });
    }
    return listOfChatModels;
  }

  @override
  Future<List<ChatMemberModel>> getMembersOfChat(String chatId) async {
    List<ChatMemberModel> chatMembersModels = [];
    List<ChatMemberEntity> chatMembersEntities =
        await _databaseProvider.getMembersOfChat(chatId);
    chatMembersEntities.forEach((chatMemberEntity) async {
      final String image = await _storageProvider.downloadImage(
        userId: chatMemberEntity.uid,
      );
      if (image != null) {
        chatMemberEntity.copyWith(
          image: image,
        );
      }
      chatMembersModels.add(ChatMemberMapper.toModel(chatMemberEntity));
    });
    return chatMembersModels;
  }
}
