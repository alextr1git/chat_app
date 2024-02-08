import 'dart:async';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:firebase_database/firebase_database.dart';

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
  Future<ChatEntity?> joinChat(
    String chatID,
    String userID,
  ) async {
    Map<Object?, Object?>? data = await getDataFromRequest(
        databaseReference: _databaseReference.child("chats/$chatID"));
    if (data != null) {
      if (await checkIfUserAlreadyInChat(
            userID: userID,
            chatID: chatID,
          ) ==
          false) {
        ChatEntity returnedChat = ChatEntity.fromJson(
          data,
          chatID,
        );
        await addChatToChatUsersAndUserChats(
          userID: userID,
          chatID: chatID,
        );
        String username = await getUsernameByID(userID);
        String secondPartOfMessage =
            LocaleKeys.service_messages_second_part_join_message.tr();
        String message = "$username $secondPartOfMessage";
        MessageEntity onSuccessMessage = MessageEntity(
          id: "0",
          senderId: "service",
          message: message,
          timeStamp: DateTime.now().millisecondsSinceEpoch,
          chatId: chatID,
        );
        postNewMessage(onSuccessMessage);
        return returnedChat;
      }
    }
    return null;
  }

  Future<bool> checkIfUserAlreadyInChat({
    required String userID,
    required String chatID,
  }) async {
    bool isUserAlreadyInChat = false;

    Map<Object?, Object?>? data = await getDataFromRequest(
        databaseReference: _databaseReference.child(" user-chats/$userID"));
    if (data != null) {
      data.forEach((dbChatID, dbChatData) {
        if (dbChatID == chatID) {
          if (dbChatData is Map<Object?, Object?>) {
            dbChatData.forEach((key, value) {
              if (key == "is-member" && value == true) {
                isUserAlreadyInChat = true;
              }
            });
          }
        }
      });
    }
    return isUserAlreadyInChat;
  }

  Future<void> addChatToChatUsersAndUserChats({
    required String userID,
    required String chatID,
  }) async {
    final DatabaseReference userChatsRef =
        _databaseReference.child(" user-chats/$userID");
    final Map<String, dynamic> userChatsData = {
      chatID: {
        "change-id": false,
        "is-listened": false,
        "is-member": true,
      }
    };

    final DatabaseReference chatUsersRef =
        _databaseReference.child("chat-users/$chatID");
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
    try {
      await removeMemberFromChatUsersAndUserChats(
        userID: userID,
        chatID: chatID,
      );
      String username = await getUsernameByID(userID);
      String secondPartOfMessage =
          LocaleKeys.service_messages_second_part_has_left_chat.tr();
      String message = "$username $secondPartOfMessage";
      MessageEntity onRemoveUserMessage = MessageEntity(
          id: "0",
          senderId: "service",
          message: message,
          timeStamp: DateTime.now().millisecondsSinceEpoch,
          chatId: chatID);
      postNewMessage(onRemoveUserMessage);
    } catch (e) {}
  }

  Future<void> removeMemberFromChatUsersAndUserChats({
    required String userID,
    required String chatID,
  }) async {
    final DatabaseReference userChatsRef =
        _databaseReference.child(" user-chats/$userID");
    final DatabaseReference chatUsersRef =
        _databaseReference.child("chat-users/$chatID");
    try {
      Map<Object?, Object?>? chatData = await getDataFromRequest(
          databaseReference: _databaseReference.child("chats/$chatID"));

      if (chatData != null && chatData["creator-id"] == userID) {
        await deleteChat(chatID: chatID);
      }

      final Map<String, dynamic> userChatsData = {
        chatID: {
          "change-id": false,
          "is-listened": false,
          "is-member": false,
        }
      };
      await userChatsRef.update(userChatsData);
      await chatUsersRef.update({userID: false});
    } catch (e) {
      throw CannotRemoveChatToUserChatListsException();
    }
  }

  Future<void> deleteChat({required String chatID}) async {
    final DatabaseReference chatsRef =
        _databaseReference.child("chats/$chatID");
    final DatabaseReference chatUsersRef =
        _databaseReference.child("chat-users/$chatID");

    Map<Object?, Object?>? usersChatsData = await getDataFromRequest(
        databaseReference: _databaseReference.child(" user-chats"));
    if (usersChatsData != null) {
      usersChatsData.forEach((userID, userData) {
        if (userData != null && userData is Map<Object?, Object?>) {
          userData.forEach((chatId, chatBool) async {
            if (chatId == chatID) {
              final Map<String, dynamic> userChatsData = {
                chatID: {
                  "change-id": false,
                  "is-listened": false,
                  "is-member": false,
                }
              };
              await _databaseReference
                  .child(" user-chats/${userID.toString()}")
                  .update(userChatsData);
            }
          });
        }
      });
    }
    await chatsRef.remove();
    await chatUsersRef.remove();
  }

  @override
  Future<void> postNewMessage(MessageEntity messageEntity) async {
    final String chatId = messageEntity.chatId;

    final DatabaseReference finalRef =
        _databaseReference.child("messages/$chatId");

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
      await notifyMembersAboutChatChanges(chatID: chatId);
    } catch (e) {
      throw CannotPostMessageException();
    }
  }

  Future<void> updateLastMessageIDOfChat(
      String chatID, String messageID) async {
    if (messageID.isNotEmpty && chatID.isNotEmpty) {
      final DatabaseReference chatRef =
          _databaseReference.child("chats/$chatID");
      await chatRef.update({"last-message-id": messageID});
    }
  }

  @override
  Stream<List<MessageEntity>> getMessagesForChat(ChatEntity chatEntity) {
    final String chatId = chatEntity.id;
    final DatabaseReference finalRef =
        _databaseReference.child("messages/$chatId");

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

  Future<ChatEntity?> getChatByID(String chatID) async {
    final chatSnapshot = await _databaseReference.child("chats/$chatID").get();
    if (chatSnapshot.exists && chatSnapshot.value != null) {
      var chat = chatSnapshot.value!;
      if (chat is Map<Object?, Object?>) {
        return ChatEntity.fromJson(chat, chatID);
      }
    }
    return null;
  }

  List<String?> getListOfChatIDs(var idsMapJSON) {
    List<String> listOfChatIDs = [];
    var idsMap = idsMapJSON.snapshot.value;
    if (idsMap != null && idsMap is Map<Object?, Object?>) {
      idsMap.forEach((chatID, chatData) {
        if (chatData != null && chatData is Map<Object?, Object?>) {
          chatData.forEach((key, value) {
            if (key == "is-member" && value == true) {
              listOfChatIDs.add(chatID.toString());
            }
          });
        }
      });
    }
    return listOfChatIDs;
  }

  FutureOr<List<ChatEntity>> getListOfChatEntities(var listOfChatIDs) async {
    List<ChatEntity> listOfChatEntities = [];

    for (var chatID in listOfChatIDs) {
      if (chatID != null) {
        Map<Object?, Object?>? chatMap = await getDataFromRequest(
          databaseReference: _databaseReference.child("chats/$chatID"),
        );
        if (chatMap != null && chatMap.length > 3) {
          listOfChatEntities.add(ChatEntity.fromJson(chatMap, chatID));
        }
      }
    }
    return listOfChatEntities;
  }

  @override
  Stream<List<ChatEntity>> getChatsForUser(String userId) {
    final DatabaseReference userChatsUserIDRef =
        _databaseReference.child(" user-chats/$userId");
    Stream<List<String?>> userChatIDsStream = (userChatsUserIDRef.onValue)
        .map((listOfChatIDsJSON) => getListOfChatIDs(listOfChatIDsJSON));

    Stream<List<ChatEntity>> streamOfChats = userChatIDsStream
        .asyncMap((listOfChatIDs) => getListOfChatEntities(listOfChatIDs));

    return streamOfChats;
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
    try {
      Map<Object?, Object?>? users = await getDataFromRequest(
        databaseReference: _databaseReference.child("chat-users/$chatId"),
      );

      if (users != null) {
        users.forEach((userID, userIDBool) {
          mapOfData[userID.toString()] = {"isMember": userIDBool.toString()};
        });
      }
    } catch (e) {
      throw CannotGetMembersOfChatStatusException();
    }
    return mapOfData;
  }

  Future<List<String>> getListOfActiveMembersOfChat(String chatId) async {
    List<String> listOfMembersIDs = [];
    try {
      Map<Object?, Object?>? users = await getDataFromRequest(
        databaseReference: _databaseReference.child("chat-users/$chatId"),
      );
      if (users != null) {
        users.forEach((userID, userIDBool) {
          if (userIDBool == true) {
            listOfMembersIDs.add(userID.toString());
          }
        });
      }
    } catch (e) {
      throw CannotGetMembersOfChatStatusException();
    }
    return listOfMembersIDs;
  }

  Future<String> getUserDataFromDB(String userID) async {
    String username = "";
    Map<Object?, Object?>? user = await getDataFromRequest(
      databaseReference: _databaseReference.child("users/$userID"),
    );
    if (user != null) {
      username = user["username"].toString();
    }
    return username;
  }

  @override
  Future<Map<String, MessageEntity>> getLastMessagesOfChat(
      List<ChatEntity> listOfChatEntities) async {
    Map<String, MessageEntity> mapOfMessageEntitiesToChatEntities = {};
    for (ChatEntity chatEntity in listOfChatEntities) {
      Map<Object?, Object?>? messageData = await getDataFromRequest(
          databaseReference: _databaseReference
              .child("messages/${chatEntity.id}/${chatEntity.lastMessageId}"));
      if (messageData != null) {
        mapOfMessageEntitiesToChatEntities[chatEntity.id] =
            MessageEntity.fromJson(
                messageData, chatEntity.id, chatEntity.lastMessageId);
      }
    }
    return mapOfMessageEntitiesToChatEntities;
  }

  @override
  Future<void> updateUsernameData(String userID, String username) async {
    final DatabaseReference usersRef =
        _databaseReference.child("users/$userID");
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
    Map<Object?, Object?>? userData = await getDataFromRequest(
      databaseReference: _databaseReference.child("users/$userID"),
    );
    if (userData != null) {
      username = userData["username"].toString();
    }
    return username;
  }

  @override
  Future<void> setListeningStatus({
    required String chatID,
    required String userID,
    required bool status,
  }) async {
    try {
      final DatabaseReference databaseReference =
          _databaseReference.child(" user-chats/$userID/$chatID");
      Map<Object?, Object?>? usersChatsData = await getDataFromRequest(
        databaseReference: databaseReference,
      );
      if (usersChatsData != null) {
        usersChatsData.forEach((chatID, chatData) async {
          if (chatData is Map<Object?, Object?>) {
            final Map<String, dynamic> newData = {
              "change-id": chatData["change-id"],
              "is-listened": status,
              "is-member": true,
            };
            await databaseReference.update(newData);
          }
        });
      }
    } catch (e) {
      throw CannotSetListeningStatusException();
    }
  }

  @override
  Future<void> notifyMembersAboutChatChanges({
    required String chatID,
  }) async {
    try {
      List<String> listOfMembers = await getListOfActiveMembersOfChat(chatID);
      for (String userID in listOfMembers) {
        DatabaseReference databaseReference =
            _databaseReference.child(" user-chats/$userID/$chatID");
        Map<Object?, Object?>? usersChatsData = await getDataFromRequest(
          databaseReference: databaseReference,
        );
        if (usersChatsData != null) {
          if (usersChatsData["is-listened"] == true) {
            final Map<String, dynamic> newData = {
              "change-id": !(usersChatsData["change-id"] as bool),
              "is-listened": usersChatsData["is-listened"],
              "is-member": usersChatsData["is-member"],
            };
            await databaseReference.update(newData);
          }
        }
      }
    } catch (e) {
      throw CannotNotifyMembersException();
    }
  }

  Future<Map<Object?, Object?>?> getDataFromRequest({
    required DatabaseReference databaseReference,
  }) async {
    final DataSnapshot snapshot = await databaseReference.get();
    if (snapshot.exists && snapshot.value != null) {
      Object dbData = snapshot.value!;
      if (dbData is Map<Object?, Object?>) {
        return dbData;
      }
    }
    return null;
  }
}
