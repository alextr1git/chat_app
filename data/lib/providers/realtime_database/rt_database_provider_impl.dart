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
  Future<void> createNewChat(ChatEntity chatEntity, String userId) async {
    final String chatId = chatEntity.id;
    final DatabaseReference chatsRef = _databaseReference.child("chats");

    final DatabaseReference chatsUsersRef =
        _databaseReference.child("chat-users").child(chatId);

    final String title = chatEntity.title;
    final int messagesCount = chatEntity.messageCount;
    final String lastMessageId = chatEntity.lastMessageId;
    final num timestamp = chatEntity.timestamp;

    final Map<String, dynamic> chatsData = {
      "title": title,
      "messages-count": messagesCount,
      "last-message-id": lastMessageId,
      "timestamp": timestamp,
    };

    final Map<String, dynamic> chatUsersData = {userId: true};
    try {
      await chatsRef.push().update(chatsData);
      await chatsUsersRef.update(chatUsersData);
    } catch (e) {}
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

  @override
  Future<List<ChatMemberEntity>> getMembersOfChat(String chatId) async {
    List<ChatMemberEntity> listOfChatMembers = [];
    List<String> listOfUID = await getUserIDS(chatId);
    try {
      listOfUID.forEach((id) async {
        ChatMemberEntity newChatMemberEntity = ChatMemberEntity(uid: id);
        final DatabaseReference usersF =
            _databaseReference.child("users").child(id);
        final DataSnapshot snapshotSecond =
            await usersF.get(); //user-id -> username: usernameUser?

        if (snapshotSecond.exists) {
          var username = snapshotSecond.value!;
          if (username != null && username is Map<Object?, Object?>) {
            var usernameValue = username["username"];
            //only once
            newChatMemberEntity.copyWith(username: usernameValue.toString());
          }
        }
        listOfChatMembers.add(newChatMemberEntity);
      });
    } catch (e) {
      print('Error in provider: ${e.toString()}');
    }
    return listOfChatMembers;
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
}
