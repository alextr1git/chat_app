import 'dart:async';

import 'package:data/entities/chat_members/chat_member_entity.dart';
import 'package:data/entities/chats/chat_entity.dart';
import 'package:data/entities/chats/message_entity.dart';
import 'package:data/providers/realtime_database/rt_database_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class RealTimeDatabaseProviderImpl implements RealTimeDatabaseProvider {
  final DatabaseReference _databaseReference;

  RealTimeDatabaseProviderImpl({required DatabaseReference databaseReference})
      : _databaseReference = databaseReference;

  @override
  Future<ChatEntity?> createNewChat(String chatTitle, String userId) async {
    final DatabaseReference chatsRef = _databaseReference.child("chats");

    try {
      final String chatKey = (await chatsRef.push().key).toString();
      final ChatEntity newChatEntity = ChatEntity(
        id: chatKey,
        title: chatTitle,
        lastMessageId: "",
        timestamp: 0,
        messageCount: 0,
        creatorId: userId,
      );
      final chatData = {
        "id": newChatEntity.id,
        "title": newChatEntity.title,
        "last-message-id": newChatEntity.lastMessageId,
        "timestamp": newChatEntity.timestamp,
        "message-count": newChatEntity.messageCount,
        "creator-id": newChatEntity.creatorId,
      };
      await chatsRef.child(chatKey).update(chatData);
      await addChatToChatUsersAndUserChats(
        userID: userId,
        chatID: newChatEntity.id,
      );
      return newChatEntity;
    } catch (e) {}
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
      print(e.toString());
    }
  }

  @override
  Future<void> postNewMessage(MessageEntity messageEntity) async {
    final String chatId = messageEntity.chatId;
    final String messageId = messageEntity.id;

    final DatabaseReference finalRef =
        _databaseReference.child("messages").child(chatId).child(messageId);

    final String senderId = messageEntity.senderId;
    final String message = messageEntity.message;
    final num timestamp = messageEntity.timeStamp;

    final Map<String, dynamic> data = {
      "message": message,
      "sender-id": senderId,
      "timestamp": timestamp,
    };
    try {
      await finalRef.update(data);
    } catch (e) {}
  }

  @override
  Stream<MessageEntity> getMessagesForChat(ChatEntity chatEntity) {
    StreamController<MessageEntity> messageController =
        StreamController<MessageEntity>();

    final String chatId = chatEntity.id;
    final DatabaseReference finalRef =
        _databaseReference.child("messages").child(chatId);

    StreamSubscription<DatabaseEvent> subscription =
        finalRef.onValue.listen((DatabaseEvent event) {
      final allMessages = event.snapshot.value;

      if (allMessages != null && allMessages is Map<Object?, Object?>) {
        allMessages.forEach((key, value) {
          try {
            String messageId = key.toString();
            if (value != null && value is Map<Object?, Object?>) {
              MessageEntity messageEntity =
                  MessageEntity.fromJson(value, chatId, messageId);
              messageController.add(messageEntity);
            }
          } catch (e) {
            print("Error converting message: $e");
          }
        });
      } else {
        print("Correct message Type is:  ${allMessages.runtimeType}");
      }
    });
    return messageController.stream;
  }

  @override
  Future<List<ChatEntity>?> getChatsForUser(String userId) async {
    List<String> listOfChatIds = [];
    List<ChatEntity> listOfChats = [];

    final DatabaseReference finalRef =
        _databaseReference.child(" user-chats/$userId");

    final DataSnapshot snapshot = await finalRef.get();
    if (snapshot.exists) {
      Object data = snapshot.value!;

      if (data != null && data is Map<Object?, Object?>) {
        data.forEach((key, value) {
          try {
            listOfChatIds.add(key.toString());
          } catch (e) {
            print("Error converting message: $e");
          }
        });
        final chatsSnapshot = await _databaseReference.child("chats").get();

        if (chatsSnapshot.exists) {
          Object chats = chatsSnapshot.value!;
          if (chats != null && chats is Map<Object?, Object?>) {
            try {
              chats.forEach((key, value) {
                if (listOfChatIds.contains(key)) {
                  var valueMap = value as Map<Object?, Object?>;
                  listOfChats
                      .add(ChatEntity.fromJson(valueMap, key.toString()));
                }
              });
            } catch (e) {
              print("Error converting chats ID to Chats: $e");
            }
          }
        }

        return listOfChats;
      } else {
        print('No data available.');
      }
    }
  }

  Future<List<String>> getUserIDS(String chatId) async {
    List<String> listOfUID = [];

    final DatabaseReference chatUsersRef =
        _databaseReference.child("chat-users");

    try {
      final DataSnapshot snapshot = await chatUsersRef.get();
//chat-id -> {users}

      if (snapshot.exists) {
        Object chats = snapshot.value!;

        if (chats != null && chats is Map<Object?, Object?>) {
          chats.forEach((chatID, chatIDValue) {
            if (chatID.toString() == chatId) {
              var membersOfChat =
                  chatIDValue as Map<Object?, Object?>; //{userid : true}
              membersOfChat.forEach((userID, _) async {
                listOfUID.add(userID.toString());
              });
            }
          });
        }
      }
    } catch (e) {
      print("Error occured!");
    }
    return listOfUID;
  }

  Future<List<Map<String?, String?>>> getUsersDataFromDB(
      List<String> listOfUID) async {
    List<Map<String?, String?>> usersData = [];
    final DatabaseReference usersReference = _databaseReference.child("users");
    final DataSnapshot usersSnapshot = await usersReference.get(); // {user-id}:
    // {username:Alexander}
    if (usersSnapshot.exists) {
      var users = usersSnapshot.value!;
      if (users != null && users is Map<Object?, Object?>) {
        users.forEach((userId, userData) {
          if (userData != null &&
              userData is Map<Object?, Object?> &&
              listOfUID.contains(userId)) {
            var username = userData["username"];
            Map<String, String> data = {"$userId": "$username"};
            usersData.add(data);
          }
        });
      }
    }
    return usersData;
  }

  @override
  Future<List<ChatMemberEntity>> getMembersOfChat(String chatId) async {
    List<String> listOfUID = await getUserIDS(chatId);
    List<Map<String?, String?>> listOfUsersData =
        await getUsersDataFromDB(listOfUID);
    List<ChatMemberEntity> listOfChatMembersEntities = [];
    listOfUsersData.forEach((userMap) {
      userMap.forEach((key, value) {
        ChatMemberEntity newChatMemberEntity =
            ChatMemberEntity(uid: key.toString(), username: value);
        listOfChatMembersEntities.add(newChatMemberEntity);
      });
    });
    return listOfChatMembersEntities;
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
    } catch (e) {}
  }

  @override
  Future<String> getUsernameByID(String userID) async {
    String username = "";
    final DatabaseReference usersRef =
        _databaseReference.child("users/$userID");
    DataSnapshot usersSnapshot = await usersRef.get();
    if (usersSnapshot.exists) {
      var userData = usersSnapshot.value!;
      if (userData != null && userData is Map<Object?, Object?>) {
        username = userData["username"].toString();
      }
    }
    return username;
  }

  @override
  Future<ChatEntity?> joinChat(String chatID, String userID) async {
    final DatabaseReference chatRef = _databaseReference.child("chats/$chatID");
    final DataSnapshot snapshot = await chatRef.get();
    if (snapshot.exists) {
      Object data = snapshot.value!;
      if (data != null && data is Map<Object?, Object?>) {
        ChatEntity returnedChat = ChatEntity.fromJson(data, chatID);
        await addChatToChatUsersAndUserChats(
          userID: userID,
          chatID: chatID,
        );
        return returnedChat;
      }
    }
  }
}
