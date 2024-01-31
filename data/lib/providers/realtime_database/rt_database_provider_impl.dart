import 'dart:async';
import 'package:data/entities/chat_members/chat_member_entity.dart';
import 'package:data/entities/chats/message_entity.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../data.dart';

class RealTimeDatabaseProviderImpl implements RealTimeDatabaseProvider {
  final DatabaseReference _databaseReference;

  RealTimeDatabaseProviderImpl({required DatabaseReference databaseReference})
      : _databaseReference = databaseReference;

  @override
  Future<ChatEntity?> createNewChat(
      ChatEntity chatEntity, String userId) async {
    final DatabaseReference chatsRef = _databaseReference.child("chats");

    try {
      //get generated ID of new chat
      final String newChatID = (chatsRef.push().key).toString();
      //update ID of chatEntity with new ID
      ChatEntity newChatEntity = chatEntity.copyWith(
        id: newChatID,
        creatorId: userId,
      );
      //prepare chatData for database
      final chatData = {
        "id": newChatEntity.id,
        "title": newChatEntity.title,
        "last-message-id": newChatEntity.lastMessageId,
        "timestamp": newChatEntity.timestamp,
        "message-count": newChatEntity.messageCount,
        "creator-id": newChatEntity.creatorId,
        "color": newChatEntity.color,
      };
      //add new chat to db
      await chatsRef.child(newChatID).update(chatData);
      //add new chat to list of chats for user-creator and also add user to list of users for current chat
      await addChatToChatUsersAndUserChats(
        userID: userId,
        chatID: newChatEntity.id,
      );
      return newChatEntity;
    } catch (e) {
      throw CannotCreateChatException();
    }
  }

  @override
  Future<ChatEntity?> joinChat(String chatID, String userID) async {
    final DatabaseReference chatRef = _databaseReference.child("chats/$chatID");
    final DataSnapshot snapshot = await chatRef.get();
    if (snapshot.exists && snapshot.value != null) {
      Object data = snapshot.value!;
      if (data is Map<Object?, Object?>) {
        if (await checkIfUserAlreadyInChat(userID: userID, chatID: chatID) ==
            false) {
          ChatEntity returnedChat = ChatEntity.fromJson(data, chatID);
          await addChatToChatUsersAndUserChats(
            userID: userID,
            chatID: chatID,
          );
          return returnedChat;
        }
      }
    }
    return null;
  }

  Future<bool> checkIfUserAlreadyInChat({
    required String userID,
    required String chatID,
  }) async {
    bool isUserAlreadyInChat = false;
    final DatabaseReference chatUsersRef =
        _databaseReference.child(" user-chats/$userID");
    final DataSnapshot snapshot = await chatUsersRef.get();
    if (snapshot.exists && snapshot.value != null) {
      Object data = snapshot.value!;
      if (data is Map<Object?, Object?>) {
        data.forEach((dbChatID, dbChatBool) {
          if (dbChatID == chatID && dbChatBool == true) {
            isUserAlreadyInChat = true;
          }
        });
      }
    }
    return isUserAlreadyInChat;
  }

  Future<void> addChatToChatUsersAndUserChats({
    required String userID,
    required String chatID,
  }) async {
    final DatabaseReference userChatsRef =
        _databaseReference.child(" user-chats").child(userID);
    final Map<String, dynamic> userChatsData = {chatID: true};

    final DatabaseReference chatUsersRef =
        _databaseReference.child("chat-users").child(chatID);
    final Map<String, dynamic> chatUsersData = {userID: true};
    try {
      await userChatsRef.update(userChatsData);
      await chatUsersRef.update(chatUsersData);
    } catch (e) {
      throw CannotAddChatToUserChatListsException();
    }
  }

  @override
  Future<void> removeUserFromChat({
    required String userID,
    required String chatID,
  }) async {
    await removeMemberFromChatUsersAndUserChats(
      userID: userID,
      chatID: chatID,
    );
  }

  Future<void> removeMemberFromChatUsersAndUserChats({
    required String userID,
    required String chatID,
  }) async {
    final DatabaseReference chatsRef =
        _databaseReference.child("chats").child(chatID);
    final DatabaseReference userChatsRef =
        _databaseReference.child(" user-chats").child(userID);
    final DatabaseReference chatUsersRef =
        _databaseReference.child("chat-users").child(chatID);
    try {
      final DataSnapshot snapshot = await chatsRef.get();
      if (snapshot.exists && snapshot.value != null) {
        Object chatData = snapshot.value!;
        if (chatData is Map<Object?, Object?>) {
          if (chatData["creator-id"] == userID) {
            await deleteChat(chatID: chatID);
          }
        }
      }
      await userChatsRef.update({chatID: false});
      await chatUsersRef.update({userID: false});
    } catch (e) {
      throw CannotRemoveChatToUserChatListsException();
    }
  }

  Future<void> deleteChat({required String chatID}) async {
    final DatabaseReference chatsRef =
        _databaseReference.child("chats").child(chatID);
    final DatabaseReference chatUsersRef =
        _databaseReference.child("chat-users").child(chatID);
    final DatabaseReference userChatsRef =
        _databaseReference.child(" user-chats");
    final DataSnapshot snapshot = await userChatsRef.get();
    if (snapshot.exists && snapshot.value != null) {
      Object usersChatsData = snapshot.value!;
      if (usersChatsData is Map<Object?, Object?>) {
        usersChatsData.forEach((userID, userData) {
          if (userData != null && userData is Map<Object?, Object?>) {
            userData.forEach((chatId, chatBool) async {
              if (chatId == chatID) {
                await userChatsRef
                    .child(userID.toString())
                    .update({chatID: false});
              }
            });
          }
        });
      }
    }
    await chatsRef.remove();
    await chatUsersRef.remove();
  }

  @override
  Future<void> postNewMessage(MessageEntity messageEntity) async {
    final String chatId = messageEntity.chatId;

    final DatabaseReference finalRef =
        _databaseReference.child("messages").child(chatId);

    final DatabaseReference messageRef = finalRef.push();
    final messageDBID = messageRef.key;
    final String senderId = messageEntity.senderId;
    final String message = messageEntity.message;
    final int timestamp = messageEntity.timeStamp;

    final Map<String, dynamic> data = {
      "message": message,
      "sender-id": senderId,
      "timestamp": timestamp,
    };
    try {
      await messageRef.update(data);
      await updateLastMessageIDOfChat(
        chatId,
        messageDBID!,
      );
    } catch (e) {
      throw CannotPostMessageException();
    }
  }

  Future<void> updateLastMessageIDOfChat(
      String chatID, String messageID) async {
    if (messageID.isNotEmpty && chatID.isNotEmpty) {
      final DatabaseReference chatRef =
          _databaseReference.child("chats").child(chatID);
      await chatRef.update({"last-message-id": messageID});
    }
  }

  @override
  Stream<List<MessageEntity>> getMessagesForChat(ChatEntity chatEntity) {
    final String chatId = chatEntity.id;
    final DatabaseReference finalRef =
        _databaseReference.child("messages").child(chatId);

    Stream dbStream = finalRef.orderByChild('timestamp').onValue;

    return dbStream.map((var messagesMapJSON) =>
        transformMapToMessageEntity(messagesMapJSON, chatId));
  }

  List<MessageEntity> transformMapToMessageEntity(
      var messagesMapJSON, String chatID) {
    MessageEntity messageEntity = MessageEntity.empty;
    List<MessageEntity> listOfMessageEntities = [];
    var messageMap = messagesMapJSON.snapshot.value;
    if (messageMap != null && messageMap is Map<Object?, Object?>) {
      messageMap.forEach((messageId, messageData) {
        try {
          if (messageData != null && messageData is Map<Object?, Object?>) {
            messageEntity = MessageEntity.fromJson(
                messageData, chatID, messageId.toString());
            listOfMessageEntities.add(messageEntity);
            listOfMessageEntities
                .sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
          }
        } catch (e) {
          throw CannotTransformJSONToMessageEntityException();
        }
      });
    }
    return listOfMessageEntities;
  }

  @override
  Future<List<ChatEntity>?> getChatsForUser(String userId) async {
    List<String> listOfChatIds = [];
    List<ChatEntity> listOfChats = [];

    final DatabaseReference userChatsUserIDRef =
        _databaseReference.child(" user-chats/$userId");

    final DataSnapshot snapshot = await userChatsUserIDRef.get();
    if (snapshot.exists && snapshot.value != null) {
      Object listOfChatsForUserData = snapshot.value!;
      if (listOfChatsForUserData is Map<Object?, Object?>) {
        listOfChatsForUserData.forEach((chatID, chatBool) {
          try {
            if (chatBool == true) {
              listOfChatIds.add(chatID.toString());
            }
          } catch (e) {
            throw CannotTransformJSONToMessageEntityException();
          }
        });
        final chatsSnapshot = await _databaseReference.child("chats").get();

        if (chatsSnapshot.exists && chatsSnapshot.value != null) {
          var chats = chatsSnapshot.value!;
          if (chats is Map<Object?, Object?>) {
            try {
              chats.forEach((key, value) {
                if (listOfChatIds.contains(key)) {
                  var valueMap = value as Map<Object?, Object?>;
                  listOfChats
                      .add(ChatEntity.fromJson(valueMap, key.toString()));
                }
              });
            } catch (e) {
              throw CannotGetChatEntityFromChatIDException();
            }
          }
        }
        return listOfChats;
      } else {
        throw CannotGetAvailableChatsForUserException();
      }
    }
    return null;
  }

  @override
  Future<List<ChatMemberEntity>> getMembersOfChat(String chatId) async {
    Map<String, Map<String, String>> mapOfUIDtoIsMember =
        await getMapUserIsMember(chatId);

    List<ChatMemberEntity> listOfChatMemberEntities = [];
    for (var userElement in mapOfUIDtoIsMember.entries) {
      String username = await getUserDataFromDB(userElement.key);
      ChatMemberEntity newChatMemberEntity = ChatMemberEntity(
          uid: userElement.key,
          username: username,
          isMember: (userElement.value["isMember"] == 'true'));
      listOfChatMemberEntities.add(newChatMemberEntity);
    }

    return listOfChatMemberEntities;
  }

  Future<Map<String, Map<String, String>>> getMapUserIsMember(
      String chatId) async {
    Map<String, Map<String, String>> mapOfData = {};

    final DatabaseReference chatUsersRef =
        _databaseReference.child("chat-users").child(chatId);

    try {
      final DataSnapshot snapshot = await chatUsersRef.get();

      if (snapshot.exists && snapshot.value != null) {
        var users = snapshot.value!;
        if (users is Map<Object?, Object?>) {
          users.forEach((userID, userIDBool) {
            mapOfData[userID.toString()] = {"isMember": userIDBool.toString()};
          });
        }
      }
    } catch (e) {
      throw CannotGetMembersOfChatStatusException();
    }
    return mapOfData;
  }

  Future<String> getUserDataFromDB(String userID) async {
    String username = "";
    final DatabaseReference userReference =
        _databaseReference.child("users").child(userID);
    final DataSnapshot userSnapshot = await userReference.get();

    if (userSnapshot.exists && userSnapshot.value != null) {
      var user = userSnapshot.value!;
      if (user is Map<Object?, Object?>) {
        username = user["username"].toString();
      }
    }
    return username;
  }

  @override
  Future<Map<String, MessageEntity>> getLastMessagesOfChat(
      List<ChatEntity> listOfChatEntities) async {
    Map<String, MessageEntity> mapOfMessageEntitiesToChatEntities = {};
    for (ChatEntity chatEntity in listOfChatEntities) {
      final DatabaseReference messageRef = _databaseReference
          .child("messages")
          .child(chatEntity.id)
          .child(chatEntity.lastMessageId);
      final DataSnapshot snapshot = await messageRef.get();
      if (snapshot.exists && snapshot.value != null) {
        Object messageData = snapshot.value!;
        if (messageData is Map<Object?, Object?>) {
          mapOfMessageEntitiesToChatEntities[chatEntity.id] =
              MessageEntity.fromJson(
                  messageData, chatEntity.id, chatEntity.lastMessageId);
        }
      }
    }
    return mapOfMessageEntitiesToChatEntities;
  }

  @override
  Future<void> updateUsernameData(String userId, String username) async {
    final DatabaseReference usersRef =
        _databaseReference.child("users/$userId");

    final Map<String, dynamic> usersData = {
      "username": username,
    };
    try {
      await usersRef.update(usersData);
    } catch (e) {
      throw CannotUpdateUsernameException();
    }
  }

  @override
  Future<String> getUsernameByID(String userID) async {
    String username = "";
    final DatabaseReference usersRef =
        _databaseReference.child("users/$userID");
    DataSnapshot usersSnapshot = await usersRef.get();
    if (usersSnapshot.exists && usersSnapshot.value != null) {
      var userData = usersSnapshot.value!;
      if (userData is Map<Object?, Object?>) {
        username = userData["username"].toString();
      }
    }
    return username;
  }
}
