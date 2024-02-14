import 'package:data/entities/chats/message_entity.dart';
import 'package:domain/domain.dart';

abstract class MessageMapper {
  static MessageEntity toEntity(MessageModel model) {
    return MessageEntity(
      id: model.id,
      chatId: model.chatId,
      senderId: model.senderId,
      message: model.message,
      timeStamp: model.timeStamp,
    );
  }

  static MessageModel toModel(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      chatId: entity.chatId,
      senderId: entity.senderId,
      message: entity.message,
      timeStamp: entity.timeStamp,
    );
  }
}
