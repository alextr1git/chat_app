import 'package:data/entities/chats/message_entity.dart';
import 'package:data/providers/realtime_database/rt_database_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class RealTimeDatabaseProviderImpl implements RealTimeDatabaseProvider {
  final DatabaseReference _databaseReference;

  RealTimeDatabaseProviderImpl({required DatabaseReference databaseReference})
      : _databaseReference = databaseReference;

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
      await finalRef.set(data);
      print("Data has been written");
    } catch (e) {}
  }
}
