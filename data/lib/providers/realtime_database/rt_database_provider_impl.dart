import 'dart:async';

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
      print("Data has been written");
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
        print("list of chats: $listOfChats");
        return listOfChats;
      } else {
        print('No data available.');
      }
    }
  }
}
