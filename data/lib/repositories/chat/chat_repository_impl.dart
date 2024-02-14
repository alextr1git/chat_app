import 'dart:async';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

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
  Future<ChatModel?> createNewChat(ChatModel chatModel) async {
    UserEntity? userEntity = _authProvider.getCurrentUserEntity();
    if (userEntity != null) {
      final ChatEntity? chatEntity = await _databaseProvider.createNewChat(
          ChatMapper.toEntity(chatModel), userEntity.id);
      if (chatEntity != null) {
        return ChatMapper.toModel(chatEntity);
      }
    }
    return null;
  }

  @override
  Stream<List<MessageModel>> getMessagesForChat(ChatModel chatModel) {
    ChatEntity chatEntity = ChatMapper.toEntity(chatModel);
    Stream entitiesStream = _databaseProvider.getMessagesForChat(chatEntity);
    return entitiesStream
        .map((listOfEntities) => listOfEntitiesToListOfModels(listOfEntities));
  }

  List<MessageModel> listOfEntitiesToListOfModels(
      List<MessageEntity> listOfEntities) {
    List<MessageModel> listOfModels = [];
    for (var entity in listOfEntities) {
      listOfModels.add(MessageMapper.toModel(entity));
    }
    return listOfModels;
  }

  @override
  Stream<List<ChatModel>> getChatsForUser() {
    UserEntity? userEntity = _authProvider.getCurrentUserEntity();
    if (userEntity != null) {
      String userId = userEntity.id;
      Stream<List<ChatEntity>> streamOfListOfChatEntities =
          _databaseProvider.getChatsForUser(userId);
      return streamOfListOfChatEntities
          .map((listOfChatEntities) => getListOfChatModel(listOfChatEntities));
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  List<ChatModel> getListOfChatModel(List<ChatEntity> listOfChatEntites) {
    List<ChatModel> listOfChatModel = [];
    for (ChatEntity chatEntity in listOfChatEntites) {
      listOfChatModel.add(ChatMapper.toModel(chatEntity));
    }
    return listOfChatModel;
  }

  @override
  Future<List<ChatMemberModel>> getMembersOfChat(String chatId) async {
    List<ChatMemberModel> chatMembersModels = [];
    List<ChatMemberEntity> chatMembersEntities =
        await _databaseProvider.getMembersOfChat(chatId);
    for (var chatMemberEntity in chatMembersEntities) {
      final String image = await _storageProvider.downloadImage(
        userId: chatMemberEntity.uid,
      );

      if (image != "") {
        final ChatMemberEntity newChatMemberEntity = chatMemberEntity.copyWith(
          image: image,
        );
        chatMembersModels.add(ChatMemberMapper.toModel(newChatMemberEntity));
      } else {
        chatMembersModels.add(ChatMemberMapper.toModel(chatMemberEntity));
      }
    }
    return chatMembersModels;
  }

  @override
  Future<ChatModel?> joinChat(String chatID) async {
    UserEntity? userEntity = _authProvider.getCurrentUserEntity();
    if (userEntity != null) {
      UserModel? userModel = UserMapper.toModel(userEntity);
      ChatEntity? chatEntity =
          await _databaseProvider.joinChat(chatID, userModel.id);
      if (chatEntity != null) {
        return ChatMapper.toModel(chatEntity);
      }
    }
    return null;
  }

  @override
  Future<void> removeUserFromChat({
    required String userID,
    required String chatID,
  }) async {
    await _databaseProvider.removeUserFromChat(
      userID: userID,
      chatID: chatID,
    );
  }

  @override
  Future<Map<String, MessageModel>> getModelsOfLastMessagesOfChat(
      List<ChatModel> listOfChatModels) async {
    Map<String, MessageEntity> mapOfChatEntitiesToMessageEntities = {};
    List<ChatEntity> listOfChatEntities = [];
    for (ChatModel chatModel in listOfChatModels) {
      listOfChatEntities.add(ChatMapper.toEntity(chatModel));
    }
    mapOfChatEntitiesToMessageEntities =
        await _databaseProvider.getLastMessagesOfChat(listOfChatEntities);
    Map<String, MessageModel> mapOfChatModelsToMessageModels = {};
    for (String chatEntityID in mapOfChatEntitiesToMessageEntities.keys) {
      if (mapOfChatEntitiesToMessageEntities[chatEntityID] != null) {
        mapOfChatModelsToMessageModels[chatEntityID] = MessageMapper.toModel(
            mapOfChatEntitiesToMessageEntities[chatEntityID]!);
      }
    }
    return mapOfChatModelsToMessageModels;
  }

  @override
  Future<void> setListeningStatus({
    required String chatID,
    required bool status,
  }) async {
    UserEntity? userEntity = _authProvider.getCurrentUserEntity();
    if (userEntity != null) {
      await _databaseProvider.setListeningStatus(
        chatID: chatID,
        userID: userEntity.id,
        status: status,
      );
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
